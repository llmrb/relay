# frozen_string_literal: true

module Relay::Routes
  class MCP::Show < MCP::Base
    prepend Relay::Hooks::RequireUser

    def call(id)
      mcp = find_mcp(id)
      form = Relay::Forms::MCP.from_model(mcp)
      if htmx?
        workspace(selected_id: mcp.id, form:)
      else
        Relay::Pages::MCP.new(self).call(selected_id: mcp.id, form:)
      end
    end
  end
end
