# frozen_string_literal: true

module Relay::Routes
  class ListContexts < Base
    prepend Relay::Hooks::RequireUser

    def call
      partial("fragments/contexts", locals:)
    end

    private

    def locals
      {contexts:, show_label: true, swap_oob: false}
    end
  end
end
