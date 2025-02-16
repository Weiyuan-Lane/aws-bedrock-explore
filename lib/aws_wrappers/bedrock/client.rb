
module AwsWrappers
  module Bedrock
    class Client
      def self.instance
        @instance ||= Aws::BedrockRuntime::Client.new(
          region: ENV["AWS_REGION"]
        )
      end

      def self.converse(configuration: nil, input_message: '')
        if !configuration.is_a?(ConfigurationTemplate)
          raise "Please pass a valid configuration object implementing \"AwsWrappers::Bedrock::Client::ConfigurationTemplate\""
        end

        configuration.converse(
          aws_bedrock_client: @instance,
          input_message: input_message
        )
      end
    end
  end
end

AwsWrappers::Bedrock::Client.instance
