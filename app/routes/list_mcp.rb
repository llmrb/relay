# frozen_string_literal: true

module Relay::Routes
  class ListMCP < Base
    prepend Relay::Hooks::RequireUser

    def call
      if htmx?
        partial("fragments/mcp/workspace", locals: {form: Relay::Forms::MCP.build(preset: "github"), mcps:, selected_id: nil})
      else
        form = Relay::Forms::MCP.build(preset: "github")
        Relay::Pages::MCP.new(self).call(form:)
      end
    end
  end
end
