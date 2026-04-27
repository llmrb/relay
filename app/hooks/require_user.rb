# frozen_string_literal: true

module Relay::Hooks
  module RequireUser
    def call(*args)
      @user = Relay::Models::User[session["user_id"]]
      @user.nil? ? r.redirect("/sign-in") : super(*args)
    end
  end
end
