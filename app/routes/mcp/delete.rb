# frozen_string_literal: true

module Relay::Routes
  class MCP::Delete < MCP::Base
    prepend Relay::Hooks::RequireUser

    def call(id)
      Relay::Models::MCP.where(id:, user_id: user.id).delete
      form = Relay::Forms::MCP.build(preset: "github")
      return workspace(form:) if htmx?
      Relay::Pages::MCP.new(self).call(form:)
    end
  end
end
