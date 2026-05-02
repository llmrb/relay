# frozen_string_literal: true

module Relay::Routes
  class ThemeStylesheet < Base
    ##
    # Serves a discovered theme stylesheet.
    # @param [String] id
    # @return [String]
    def call(id)
      response["Content-Type"] = "text/css; charset=utf-8"
      File.read(Relay.theme_path(id))
    end
  end
end
