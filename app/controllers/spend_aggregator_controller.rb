
class SpendAggregatorController < ApplicationController
  # Disable CSRF protection for testing this controller
  skip_before_action :verify_authenticity_token

  def parse
    # Parse the JSON body from the request
    request_body = request.body.read
    parsed_body = JSON.parse(request_body)

    # Extract the data parameter
    data = parsed_body['data']
    intput_message = data.respond_to?(:to_s) ? data.to_s : data

    response = AwsWrappers::Bedrock::Client.converse(
      configuration: AI_CONFIGURATION,
      input_message: intput_message
    )
    render json: response
  end

  AI_CONFIGURATION = AwsWrappers::Bedrock::Configurations::General.new(
    task: AwsWrappers::Bedrock::ClaudeConstructors::Task.new(
      outline: 'You are a personal assistant. You have been given a unstructured bank statement, and should convert into the desired structure.',
    ),
    examples: AwsWrappers::Bedrock::ClaudeConstructors::Examples.new([
      AwsWrappers::Bedrock::ClaudeConstructors::Example.new(
        input: '
          <statement>
            <accountHolder>John Doe</accountHolder>
            <accountNumber>1234567890</accountNumber>
            <statementPeriod>
              <startDate>2024-01-01</startDate>
              <endDate>2024-01-31</endDate>
            </statementPeriod>
            <summary>
              <beginningBalance currency="USD">1000.00</beginningBalance>
              <deposits currency="USD">5000.00</deposits>
              <withdrawals currency="USD">2000.00</withdrawals>
              <endingBalance currency="USD">4000.00</endingBalance>
            </summary>
          </statement>
        ',
        output: {
          name: 'John Doe',
          account_number: '1234567890',
          statement_start_date: '2024-01-01',
          statement_end_date: '2024-01-31',
          beginning_balance: '1000.00 USD',
          ending_balance: '4000.00 USD'
        }
      ),
      AwsWrappers::Bedrock::ClaudeConstructors::Example.new(
        input: 'Let\'s take a look at John Doe\'s account summary. For the period of July 1st, 2024, through July 31st, 2024, account number 2389123, belonging to John Doe, reflects the following activity. The beginning balance was SGD 2,500.00.  During the month, deposits totaled SGD 3,200.00, while withdrawals amounted to SGD 1,800.00.  Consequently, the ending balance for the period is SGD 3,900.00.',
        output: {
          name: 'John Doe',
          account_number: '2389123',
          statement_start_date: '2024-07-01',
          statement_end_date: '2024-07-31',
          beginning_balance: '1000.00 SGD',
          ending_balance: '4000.00 SGD'
        }
      )
    ]),
    response_schema: AwsWrappers::Bedrock::ClaudeConstructors::ResponseSchema.new(
      name: 'bank_statement_summary',
      description: 'Formulating bank statement summary in a structured format',
      properties: {
        name: AwsWrappers::Bedrock::ClaudeConstructors::ResponseSchemaValue.new(
          type: 'string',
          description: 'Name of the account holder'
        ),
        account_number: AwsWrappers::Bedrock::ClaudeConstructors::ResponseSchemaValue.new(
          type: 'string',
          description: 'Account number of the account holder'
        ),
        statement_start_date: AwsWrappers::Bedrock::ClaudeConstructors::ResponseSchemaValue.new(
          type: 'string',
          description: 'Start date of the statement'
        ),
        statement_end_date: AwsWrappers::Bedrock::ClaudeConstructors::ResponseSchemaValue.new(
          type: 'string',
          description: 'End date of the statement'
        ),
        beginning_balance: AwsWrappers::Bedrock::ClaudeConstructors::ResponseSchemaValue.new(
          type: 'string',
          description: 'Beginning balance of the account'
        ),
        ending_balance: AwsWrappers::Bedrock::ClaudeConstructors::ResponseSchemaValue.new(
          type: 'string',
          description: 'Ending balance of the account'
        )
      },
      required: [
        'account_number',
        'statement_start_date',
        'statement_end_date',
        'ending_balance'
      ]
    )
  )
end
