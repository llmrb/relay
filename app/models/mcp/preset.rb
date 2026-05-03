# frozen_string_literal: true

module Relay::Models
  ##
  # The {Relay::Models::MCP::Preset} module defines the preset catalog
  # and compilation rules for Relay MCP servers.
  module MCP::Preset
    extend self

    PRESETS = {
      "github" => {
        id: "github",
        title: "GitHub",
        summary: "Connect GitHub with a single token.",
        transport: "http",
        data: {"preset" => "github", "url" => "https://api.githubcopilot.com/mcp/", "headers" => {}},
        description: "Uses GitHub's hosted MCP endpoint with a Bearer token."
      },
      "forgejo" => {
        id: "forgejo",
        title: "Forgejo",
        summary: "Connect a Forgejo instance with URL and token.",
        transport: "stdio",
        data: {"preset" => "forgejo", "argv" => ["forgejo-mcp"], "cwd" => "", "env" => {}},
        description: "Requires Forgejo support to be installed on this Relay host."
      }
    }.freeze

    ##
    # @return [Array<Hash>]
    #  Returns all visible MCP presets
    def all
      PRESETS.values
    end

    ##
    # @param [String, Symbol] id
    #  The MCP preset id
    # @return [Hash, nil]
    #  Returns the preset definition for the given id
    def [](id)
      PRESETS[id.to_s]
    end

    ##
    # @param [Relay::Forms::MCP] form
    #  The preset-specific MCP form
    # @return [Hash]
    #  The persisted MCP model attributes for the preset
    def attributes_for(form)
      preset = self[form.preset]
      case preset[:transport]
      when "http" then http_attributes(form, preset)
      when "stdio" then stdio_attributes(form, preset)
      else raise ArgumentError, "Unknown MCP transport: #{preset[:transport].inspect}"
      end
    end

    def self.http_attributes(form, preset)
      {
        name: preset[:title],
        description: "",
        transport: "http",
        data: preset[:data].merge(form.data)
      }
    end
    private_class_method :http_attributes

    def self.stdio_attributes(form, preset)
      {
        name: preset[:title],
        description: "",
        transport: "stdio",
        data: preset[:data].merge(form.data)
      }
    end
    private_class_method :stdio_attributes
  end
end
