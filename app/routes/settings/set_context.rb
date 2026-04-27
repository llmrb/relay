# frozen_string_literal: true

module Relay::Routes
  class Settings::SetContext < Base
    prepend Relay::Hooks::RequireUser

    def call
      set_context
      htmx? ? render : r.redirect("/")
    end

    private

    def render
      partial("fragments/settings/set_context", locals: {models: chat_models, contexts:, messages: ctx.messages})
    end

    def set_context
      sync_context!(selected_context) if selected_context
    end

    def selected_context
      @selected_context ||= Relay::Models::Context.where(user_id: user.id, provider:, id: params["context_id"]).first
    end
  end
end
