
module AwsWrappers
  module Bedrock
    module ClaudeConstructors
      class ResponseSchemaValue
        attr_reader :type, :description, :enum

        def initialize(type: '', description: '', enum: nil)
          if !type.is_a?(String) || type.empty?
            raise ArgumentError, 'Type for response schema value must be a non-empty String'
          end
          if !description.is_a?(String) || description.empty?
            raise ArgumentError, 'Description for response schema value must be a non-empty String'
          end
          if enum != nil && (!enum.is_a?(Array) || enum.empty?)
            raise ArgumentError, 'Enum for response schema value must be a non-empty Array or nil'
          end

          if enum.is_a?(Array)
            enum.each do |item|
              if !item.is_a?(String)
                raise ArgumentError, 'Enum items for response schema value must be String'
              end
            end
          end

          @type = type
          @description = description
          @enum = enum
        end

        def content
          content = {
            type: @type,
            description: @description,
          }
          content[:enum] = @enum if @enum.is_a?(Array) && !@enum.empty?
          content
        end
      end
    end
  end
end
