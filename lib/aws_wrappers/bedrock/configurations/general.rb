
module AwsWrappers
  module Bedrock
    module Configurations
      class General
        include AwsWrappers::Bedrock::ConfigurationTemplate

        FIXED_MODEL_ID = 'anthropic.claude-3-haiku-20240307-v1:0'.freeze

        def initialize(task: nil, examples: nil, response_schema: nil)
          if !task.is_a?(AwsWrappers::Bedrock::ClaudeConstructors::Task)
            raise ArgumentError, 'Task must be an instance of Task'
          end
          if !examples.is_a?(AwsWrappers::Bedrock::ClaudeConstructors::Examples) && !examples.is_a?(AwsWrappers::Bedrock::ClaudeConstructors::Example) && examples != nil
            raise ArgumentError, 'Examples must be an instance of Examples'
          end
          if !response_schema.is_a?(AwsWrappers::Bedrock::ClaudeConstructors::ResponseSchema)
            raise ArgumentError, 'Response schema must be an instance of ResponseSchema'
          end

          @task = task
          @examples = examples
          @response_schema = response_schema
        end

        def converse(aws_bedrock_client: nil, input_message: '')
          if !aws_bedrock_client.is_a?(Aws::BedrockRuntime::Client)
            raise ArgumentError, 'aws_bedrock_client must be an instance of Aws::BedrockRuntime::Client'
          end

          if input_message.nil? || input_message.blank?
            raise ArgumentError, 'input_message must not be nil or blank'
          end

          val = aws_bedrock_client.converse(
            model_id: FIXED_MODEL_ID,
            messages: messages(input_message),
            tool_config: tool_config
          )
          decode(val)
        end

        private
          def messages(input_message)
            text = <<~TEXT
              #{@task.content}#{"#{@examples.content}\n" if @examples != nil}

              From the above, analyze the input and provide the output via function call:
              <input>
              #{input_message}
              </input>
            TEXT

            return [{
              role: "user",
              content: [{ text: text }]
            }]
          end

          def tool_config
            {
              tools: [{
                tool_spec: {
                  name: @response_schema.name,
                  description: @response_schema.description,
                  input_schema: {
                    json: {
                      type: "object",
                      properties: @response_schema.content,
                      required: @response_schema.required
                    }
                  }
                }
              }]
            }
          end

          def decode(client_output)
            if client_output&.dig(:stop_reason) == "tool_use"
              content_bodies = client_output&.dig(:output, :message, :content)
              content_bodies.each do |content|
                # Only return the tool input if the tool name matches the intended schema name
                return content&.dig(:tool_use, :input) if content&.dig(:tool_use, :name) == @response_schema.name
              end
            end

            nil
          end
      end
    end
  end
end
