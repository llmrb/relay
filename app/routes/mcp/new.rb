# frozen_string_literal: true

module Relay::Routes
  class MCP::New < MCP::Base
    prepend Relay::Hooks::RequireUser

    def call
      form = Relay::Forms::MCP.build(preset: params["preset"] || "github")
      return workspace(form:) if htmx?
      Relay::Pages::MCP.new(self).call(form:)
    end
  end
end
