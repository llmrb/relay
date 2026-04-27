# frozen_string_literal: true

module Relay::Routes
  class MCP::Update < Base
    prepend Relay::Hooks::RequireUser

    def call(id)
      mcp = find_mcp(id)
      mcp.update(
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

    private

    def find_mcp(id)
      Relay::Models::MCP.where(id:, user_id: user.id).first || raise(Sequel::NoMatchingRow)
    end

  end
end
