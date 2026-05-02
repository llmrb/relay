# frozen_string_literal: true

module Relay::Routes
  class Settings::NewContext < Base
    prepend Relay::Hooks::RequireUser

    def call
      create_context
      htmx? ? render : r.redirect("/")
    end

    private

    def render
      partial("fragments/settings/workspace", locals: {messages: ctx.messages})
    end

    def create_context
      context = Relay::Models::Context.create(user_id: user.id, provider:, model:)
      sync_context!(context)
    end
  end
end
