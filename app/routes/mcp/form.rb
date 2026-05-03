# frozen_string_literal: true

module Relay::Routes
  class MCP::Form < MCP::Base
    prepend Relay::Hooks::RequireUser

    def call
      partial("fragments/mcp/editor", locals: {form: Relay::Forms::MCP.from_params(params)})
    end
  end
end
