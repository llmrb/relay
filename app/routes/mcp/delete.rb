# frozen_string_literal: true

module Relay::Routes
  class MCP::Delete < Base
    prepend Relay::Hooks::RequireUser

    def call(id)
      Relay::Models::MCP.where(id:, user_id: user.id).delete
      Relay::Modals::MCP.new(self).modal(form: MCP::FormData.default)
    end
  end
end
