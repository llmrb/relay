# frozen_string_literal: true

module Relay::Modals
  class MCP
    def initialize(route)
      @route = route
    end

    def modal(selected_id: nil, form:)
      route.partial("fragments/mcp_modal", locals: {mcps:, selected_id:, form:}) +
        route.partial("fragments/mcp_settings", locals: {servers: mcps})
    end

    def editor(form:)
      route.partial("fragments/mcp/editor", locals: {form:})
    end

    private

    attr_reader :route

    def mcps
      Relay::Models::MCP.summary_dataset(route.user.mcps_dataset).
        reverse_order(:created_at).
        all
    end
  end
end
