# frozen_string_literal: true

module Relay::Routes
  class MCP::Toggle < Base
    prepend Relay::Hooks::RequireUser

    def call(id)
      mcp = Relay::Models::MCP.where(id:, user_id: user.id).first || raise(Sequel::NoMatchingRow)
      mcp.update(enabled: !mcp[:enabled])
      partial("fragments/mcp_settings", locals: {servers: mcps})
    end
  end
end
