# frozen_string_literal: true

module Relay::Routes
  class MCP::Toggle < MCP::Base
    prepend Relay::Hooks::RequireUser

    def call(id)
      mcp = find_mcp(id)
      mcp.update(enabled: !mcp[:enabled])
      if params["page"] == "1"
        workspace(selected_id: mcp.id, form: Relay::Forms::MCP.from_model(mcp))
      else
        partial("fragments/mcp_settings", locals: {servers: mcps, show_label: true, swap_oob: true})
      end
    end
  end
end
