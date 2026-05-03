# frozen_string_literal: true

module Relay::Routes
  class MCP::New < MCP::Base
    prepend Relay::Hooks::RequireUser

    def call
      if htmx?
        workspace(form: Relay::Forms::MCP.build(preset: params["preset"] || "github"))
      else
        form = Relay::Forms::MCP.build(preset: params["preset"] || "github")
        Relay::Pages::MCP.new(self).call(form:)
      end
    end
  end
end
