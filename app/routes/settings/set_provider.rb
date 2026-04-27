# frozen_string_literal: true

module Relay::Routes
  class Settings::SetProvider < Base
    prepend Relay::Hooks::RequireUser

    ##
    # Changes the active provider
    # @return [String]
    #  Returns a HTML fragment
    def call
      set_provider
      set_model
      htmx? ? render : r.redirect("/")
    end

    private

    def render
      partial("fragments/settings/set_provider", locals: {models: chat_models, contexts:, messages: ctx.messages})
    end

    ##
    # Sets the provider
    # @return [void]
    def set_provider
      session["provider"] = params["provider"]
      session.delete("context_id")
    end

    ##
    # Sets the model
    # @return [void]
    def set_model
      session["model"] = default_model
    end
  end
end
