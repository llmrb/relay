# frozen_string_literal: true

module Relay::Routes
  class ThemeStylesheet < Base
    ##
    # Serves the Relay theme stylesheet.
    # @return [String]
    def call(_id)
      response["Content-Type"] = "text/css; charset=utf-8"
      File.read(Relay.theme_path)
    end
  end
end
