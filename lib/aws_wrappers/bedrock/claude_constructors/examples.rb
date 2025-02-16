
module AwsWrappers
  module Bedrock
    module ClaudeConstructors
      class Examples
        def initialize(examples)
          if !examples.is_a?(Array)
            raise ArgumentError, 'Examples must be a Array'
          end

          examples.each do |example|
            if !example.is_a?(AwsWrappers::Bedrock::ClaudeConstructors::Example)
              raise ArgumentError, 'Each example must be an instance of Example'
            end
          end

          @examples = examples
        end

        def content
          return '' if @examples.empty?
          return @examples[0].content if @examples.length == 1

          examples_content = @examples.map(&:content).join("\n")
          prompt_substring = <<~TEXT
            <examples>
            #{examples_content}
            </examples>
          TEXT
        end
      end
    end
  end
end
