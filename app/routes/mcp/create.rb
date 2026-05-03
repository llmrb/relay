# frozen_string_literal: true

module Relay::Routes
  class MCP::Create < MCP::Base
    prepend Relay::Hooks::RequireUser

    def call
      form = Relay::Forms::MCP.from_params(params)
      attributes = Relay::Models::MCP::Preset.attributes_for(form).merge(enabled: false)
      mcp = Relay::Models::MCP.create({user_id: user.id}.merge(attributes))
      form = Relay::Forms::MCP.from_model(mcp)
      if htmx?
        workspace(selected_id: mcp.id, form:)
      else
        Relay::Pages::MCP.new(self).call(selected_id: mcp.id, form:)
      end
    end
  end
end
