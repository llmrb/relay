# frozen_string_literal: true

module Relay::Routes
  class ListMCP < Base
    prepend Relay::Hooks::RequireUser

    def call
      Relay::Modals::MCP.new(self).modal(form: MCP::FormData.default)
    end
  end
end
