# frozen_string_literal: true

module Relay::Routes
  class MCP::Form < Base
    prepend Relay::Hooks::RequireUser

    def call
      Relay::Modals::MCP.new(self).editor(form: MCP::FormData.from_params(params))
    end
  end
end
