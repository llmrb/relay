# frozen_string_literal: true

module Relay::Routes
  class MCP::New < Base
    prepend Relay::Hooks::RequireUser

    def call
      Relay::Modals::MCP.new(self).modal(form: MCP::FormData.default(transport: params["transport"]))
    end
  end
end
