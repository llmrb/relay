# frozen_string_literal: true

module Relay::Routes
  class ListProviders < Base
    prepend Relay::Hooks::RequireUser

    def call
      partial("fragments/providers", locals: {show_label: true})
    end
  end
end
