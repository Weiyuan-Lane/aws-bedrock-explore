
module AwsWrappers
  module Bedrock
    module ClaudeConstructors
      class Example
        def initialize(input: '', output: nil)
          if !input.is_a?(String) || input.empty?
            raise ArgumentError, 'Input for example must be a String'
          end
          if output == nil || !output
            raise ArgumentError, 'Output for example should not be falsy'
          end

          @input = input
          @output = output
        end

        def content
          if @output.respond_to?(:to_json)
            output_val = @output.to_json
          elsif @output.respond_to?(:to_s)
            output_val = @output.to_s
          else
            output_val = @output
          end

          prompt_substring = <<~TEXT
            <example>
            Input: #{@input}
            Output: #{output_val}
            </example>
          TEXT
        end
      end
    end
  end
end
