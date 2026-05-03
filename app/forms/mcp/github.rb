# frozen_string_literal: true

class Relay::Forms::MCP
  ##
  # The {Relay::Forms::MCP::GitHub} class represents form state for
  # Relay's GitHub MCP preset.
  class GitHub < self
    ##
    # @return [String]
    #  Returns the GitHub bearer token without the `Bearer ` prefix
    attr_reader :token

    ##
    # @param [String] token The GitHub bearer token without the `Bearer ` prefix
    # @param [Hash] attributes
    # @return [Relay::Forms::MCP::GitHub]
    def initialize(token: "", **attributes)
      super(**attributes)
      @token = token.to_s.strip
    end

    ##
    # @return [String]
    #  Returns the preset id
    def preset
      "github"
    end

    ##
    # @return [String]
    #  Returns the backing MCP transport
    def transport
      "http"
    end
  end
end
