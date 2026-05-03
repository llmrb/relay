# frozen_string_literal: true

module Relay::Pages
  class MCP < Base
    prepend Relay::Hooks::RequireUser

    def call(form:, selected_id: nil)
      response["content-type"] = "text/html"
      page("mcps", title: "Relay MCP", form:, selected_id:)
    end
  end
end
