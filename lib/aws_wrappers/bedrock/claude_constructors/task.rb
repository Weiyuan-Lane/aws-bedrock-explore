
module AwsWrappers
  module Bedrock
    module ClaudeConstructors
      class Task
        attr_reader :outline

        def initialize(outline: '')
          if !outline.is_a?(String) || outline.blank?
            raise ArgumentError, 'Outline for task must be a non-empty String'
          end

          @outline = outline
        end

        def content
          prompt_substring = <<~TEXT
            <task>
            #{@outline}
            </task>
          TEXT
        end
      end
    end
  end
end
