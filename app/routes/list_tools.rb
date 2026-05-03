# frozen_string_literal: true

module Relay::Routes
  class ListTools < Base
    prepend Relay::Hooks::RequireUser

    ##
    # @return [String]
    def call
      partial("fragments/tools", {locals: {tools: LLM::Tool.registry.reject(&:mcp?)}})
    end
  end
end
