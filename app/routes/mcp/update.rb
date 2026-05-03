# frozen_string_literal: true

module Relay::Routes
  class MCP::Update < MCP::Base
    prepend Relay::Hooks::RequireUser

    def call(id)
      mcp = find_mcp(id)
      form = Relay::Forms::MCP.from_params(params)
      attributes = Relay::Models::MCP::Preset.attributes_for(form).merge(enabled: !!mcp[:enabled])
      mcp.update(attributes)
      form = Relay::Forms::MCP.from_model(mcp)
      return workspace(selected_id: mcp.id, form:) if htmx?
      Relay::Pages::MCP.new(self).call(selected_id: mcp.id, form:)
    end
  end
end
