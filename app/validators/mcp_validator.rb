# frozen_string_literal: true

module Relay::Validators
  class MCPValidator
    def initialize(model)
      @model = model
    end

    def call
      validate_data
      validate_transport_fields
    end

    private

    attr_reader :model

    def validate_data
      model.errors.add(:data, "is invalid") unless model.data.is_a?(Hash)
    end

    def validate_transport_fields
      case model.transport
      when "http"
        model.errors.add(:url, "is required") if model.url.empty?
      when "stdio"
        model.errors.add(:command, "is required") if model.command.empty?
      end
    end
  end
end
