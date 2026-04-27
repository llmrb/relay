# frozen_string_literal: true

module Relay::Routes
  class MCP::Show < Base
    prepend Relay::Hooks::RequireUser

    def call(id)
      mcp = Relay::Models::MCP.where(id:, user_id: user.id).first || raise(Sequel::NoMatchingRow)
      Relay::Modals::MCP.new(self).modal(selected_id: mcp.id, form: MCP::FormData.from_model(mcp))
    end
  end
end
