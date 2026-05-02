# frozen_string_literal: true

module Relay::Routes
  class ClearAttachment < Base
    prepend Relay::Hooks::RequireUser

    def call
      attachment.clear
      response["content-type"] = "text/html"
      partial("fragments/input", locals: {swap_oob: false})
    end
  end
end
