# frozen_string_literal: true

module Relay::Forms
  ##
  # The {Relay::Forms::MCP} class represents preset-backed MCP form state.
  # It holds the shared persisted fields for Relay's MCP UI and dispatches
  # to preset-specific subclasses for GitHub and Forgejo.
  class MCP
    ##
    # @return [Integer, String, nil]
    #  Returns the MCP row id when editing an existing server
    attr_reader :id

    ##
    # @param [Relay::Models::MCP] mcp
    #  The persisted MCP server
    # @return [Relay::Forms::MCP]
    #  A preset-specific form instance
    def self.from_model(mcp)
      common = {
        id: mcp.id,
        persisted: true
      }
      case preset = mcp.data["preset"]
      when "forgejo"
        attributes = common.merge(url: mcp.env["FORGEJO_URL"], token: mcp.env["FORGEJO_TOKEN"])
        build(preset:, attributes:)
      when "github"
        attributes = common.merge(token: mcp.headers["Authorization"].to_s.delete_prefix("Bearer ").strip)
        build(preset:, attributes:)
      else
        raise ArgumentError, "Unknown MCP preset: #{mcp.data["preset"].inspect}"
      end
    end

    ##
    # @param [Hash] params
    #  The submitted MCP form params
    # @return [Relay::Forms::MCP]
    #  A preset-specific form instance
    def self.from_params(params)
      common = {
        id: params["id"],
        persisted: false
      }
      case preset = params["preset"]
      when "forgejo"
        attributes = common.merge(url: params["url"], token: params["token"])
        build(preset:, attributes:)
      when "github"
        build(preset:, attributes: common.merge(token: params["token"]))
      else
        raise ArgumentError, "Unknown MCP preset: #{params["preset"].inspect}"
      end
    end

    ##
    # @param [String] preset
    #  The MCP preset id
    # @param [Hash] attributes
    #  Shared form attributes
    # @return [Relay::Forms::MCP]
    #  A preset-specific form instance
    def self.build(preset:, attributes: {})
      case preset
      when "forgejo" then Forgejo.new(**attributes)
      when "github" then GitHub.new(**attributes)
      else raise ArgumentError, "Unknown MCP preset: #{preset.inspect}"
      end
    end

    ##
    # @param [Integer, String, nil] id
    #  The MCP row id
    # @param [Boolean] persisted
    #  Whether the form is backed by a persisted MCP row
    def initialize(id: nil, persisted: false)
      @id = id
      @persisted = persisted
    end

    ##
    # @return [Boolean]
    #  Returns true when this form was built from a persisted MCP row
    def persisted?
      @persisted
    end
  end
end
