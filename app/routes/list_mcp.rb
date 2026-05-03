# frozen_string_literal: true

module Relay::Routes
  class ListMCP < Base
    prepend Relay::Hooks::RequireUser

    def call
      Relay::Pages::MCP.new(self).call(form: Relay::Forms::MCP.build(preset: "github"))
    end
  end
end
