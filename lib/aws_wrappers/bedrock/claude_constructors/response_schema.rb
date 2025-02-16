
module AwsWrappers
  module Bedrock
    module ClaudeConstructors
      class ResponseSchema
        attr_reader :name, :description, :properties, :required

        def initialize(name: '', description: '', properties: {}, required: [])
          if !name.is_a?(String) || name.empty?
            raise ArgumentError, 'Name for response schema must be a non-empty String'
          end
          if !description.is_a?(String) || description.empty?
            raise ArgumentError, 'Description for response schema must be a non-empty String'
          end
          if !properties.is_a?(Hash) || properties.empty?
            raise ArgumentError, 'Properties for response schema must be a non-empty Hash'
          end
          if !required.is_a?(Array)
            raise ArgumentError, 'Required for response schema must be an Array'
          end

          properties.each do |_, value|
            if !value.is_a?(AwsWrappers::Bedrock::ClaudeConstructors::ResponseSchemaValue)
              raise ArgumentError, 'Each property for response schema must be an instance of ResponseSchemaValue'
            end
          end

          required.each do |item|
            if !item.is_a?(String)
              raise ArgumentError, 'Required items for response schema must be String'
            end
          end

          @name = name
          @description = description
          @properties = properties
          @required = required
        end

        def content
          result = {}
          @properties.each do |key, value|
            result[key] = value.content
          end
          result
        end
      end
    end
  end
end
