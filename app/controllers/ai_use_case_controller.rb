class AiUseCaseController < ApplicationController
  # Disable CSRF protection for testing this controller
  skip_before_action :verify_authenticity_token

  CURRENCY_CONFIGURATION = AwsWrappers::Bedrock::Configurations::General.new(
    task: AwsWrappers::Bedrock::ClaudeConstructors::Task.new(
      outline: 'From the input data, extract the currencies values for conversion on function calling',
    ),
    response_schema: AwsWrappers::Bedrock::ClaudeConstructors::ResponseSchema.new(
      name: 'currency_conversion',
      description: 'Perform currency conversion',
      properties: {
        source_currency: AwsWrappers::Bedrock::ClaudeConstructors::ResponseSchemaValue.new(
          type: 'string',
          description: 'Currency to convert from'
        ),
        target_currency: AwsWrappers::Bedrock::ClaudeConstructors::ResponseSchemaValue.new(
          type: 'string',
          description: 'Currency to convert to'
        ),
        source_currency_value: AwsWrappers::Bedrock::ClaudeConstructors::ResponseSchemaValue.new(
          type: 'number',
          description: 'Value of "source_currency"'
        ),
      },
      required: [
        'source_currency',
        'target_currency',
        'source_currency_value'
      ]
    )
  ).freeze

  def currency_conversion
    request_body = request.body.read
    parsed_body = JSON.parse(request_body)
    data = parsed_body['data']

    ai_response = AwsWrappers::Bedrock::Client.converse(
      configuration: CURRENCY_CONFIGURATION,
      input_message: data
    )

    if response.nil?
      return render json: { error: 'Input is invalid' }, status: :bad_request
    end

    converted_result = convert(ai_response)
    render json: { currency: ai_response['source_currency'], value: converted_result }
  end

  private
    def convert(ai_data)
      source_currency = ai_data['source_currency']
      source_currency_value = ai_data['source_currency_value']
      target_currency = ai_data['target_currency']

      uri = URI.parse("https://api.frankfurter.app/latest")
      uri.query = URI.encode_www_form({ base: source_currency, symbols: target_currency })
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      conversion_request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
      conversion_response = http.request(conversion_request)
      parsed_response = JSON.parse(conversion_response.body)

      retrieved_rate = parsed_response["rates"][target_currency]
      retrieved_rate * source_currency_value
    end

end
