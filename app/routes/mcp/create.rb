# frozen_string_literal: true

module Relay::Routes
  class MCP::Create < Base
    prepend Relay::Hooks::RequireUser

    def call
      mcp = Relay::Models::MCP.create(
        user_id: user.id,
        name: params["name"].to_s.strip,
        description: params["description"].to_s.strip,
        transport: params["transport"].to_s,
        enabled: params["enabled"] == "1",
        data: {
          "command" => params["command"],
          "arguments" => params["arguments"].to_s.lines,
          "cwd" => params["cwd"],
          "env" => params["env"].to_s.lines,
          "url" => params["url"],
          "headers" => params["headers"].to_s.lines
        }
      )
      Relay::Modals::MCP.new(self).modal(selected_id: mcp.id, form: MCP::FormData.from_model(mcp))
    end
  end
end
