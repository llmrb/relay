# frozen_string_literal: true

module Relay::Routes
  class ListChat < Base
    prepend Relay::Hooks::RequireUser

    def call
      partial("fragments/chat", locals: {messages: ctx.messages, swap_oob: false})
    end
  end
end
