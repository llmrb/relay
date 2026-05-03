# frozen_string_literal: true

module Relay::Routes
  class MCP::Base < Base
    private

    def find_mcp(id)
      Relay::Models::MCP.where(id:, user_id: user.id).first || raise(Sequel::NoMatchingRow)
    end

    def workspace(selected_id: nil, form:)
      partial("fragments/mcp/workspace", locals: {mcps:, selected_id:, form:}) +
        partial("fragments/mcp_settings", locals: {servers: mcps, show_label: false, swap_oob: true})
    end
  end
end
