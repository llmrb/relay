# frozen_string_literal: true

module Relay::Routes
  class Settings::SetModel < Base
    prepend Relay::Hooks::RequireUser

    def call
      set_model
      htmx? ? render : r.redirect("/")
    end

    private

    def render
      partial("fragments/settings/set_model", locals: {models: chat_models, contexts:, messages: ctx.messages})
    end

    def set_model
      session["model"] = params["model"]
      session.delete("context_id")
    end
  end
end
