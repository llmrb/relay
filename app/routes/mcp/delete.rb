# frozen_string_literal: true

module Relay::Routes
  class MCP::Delete < MCP::Base
    prepend Relay::Hooks::RequireUser

    def call(id)
      Relay::Models::MCP.where(id:, user_id: user.id).delete
      if htmx?
        workspace(form: Relay::Forms::MCP.build(preset: "github"))
      else
        form = Relay::Forms::MCP.build(preset: "github")
        Relay::Pages::MCP.new(self).call(form:)
      end
    end
  end
end
