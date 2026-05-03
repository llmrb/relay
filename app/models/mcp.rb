# frozen_string_literal: true

module Relay::Models
  class MCP < Sequel::Model
    include Relay::Model
    plugin :validation_class_methods

    set_dataset :mcps
    many_to_one :user
    validates_presence_of :user_id, :name, :transport
    validates_inclusion_of :transport, in: %w[stdio http]

    SUMMARY_COLUMNS = %i[
      id
      user_id
      name
      description
      transport
      enabled
      created_at
      updated_at
    ].freeze

    def self.dump_data(data)
      JSON.generate(data)
    end

    def self.load_data(data)
      case data
      when String then JSON.parse(data)
      when Hash, Array then data
      else {}
      end
    rescue JSON::ParserError
      {}
    end

    def self.summary_dataset(dataset = self.dataset)
      dataset.select(*SUMMARY_COLUMNS)
    end

    def self.normalize_url(value)
      url = value.to_s.strip
      return "" if url.empty?
      uri = URI.parse(url)
      uri.path = "/" if uri.path.to_s.empty?
      uri.to_s
    rescue URI::InvalidURIError
      url
    end

    ##
    # @return [Hash]
    #  Returns the parsed MCP transport data
    def data
      self.class.load_data(self[:data])
    end

    ##
    # @group stdio

    ##
    # @return [Array<String>]
    #  Returns the stdio command argv
    def argv
      transport == "stdio" ? data["argv"] || [] : []
    end

    ##
    # @return [String]
    #  Returns the stdio executable name
    def command
      argv.first.to_s
    end

    ##
    # @return [Array<String>]
    #  Returns the stdio command arguments
    def arguments
      argv.drop(1)
    end

    ##
    # @return [Hash]
    #  Returns the stdio environment variables
    def env
      transport == "stdio" ? data["env"] || {} : {}
    end

    ##
    # @return [String]
    #  Returns the stdio working directory
    def cwd
      transport == "stdio" ? data["cwd"].to_s : ""
    end
    # @endgroup

    ##
    # @group HTTP

    ##
    # @return [String]
    #  Returns the MCP HTTP endpoint URL
    def url
      self.class.normalize_url(transport == "http" ? data["url"] : nil)
    end

    ##
    # @return [Hash]
    #  Returns the MCP HTTP headers
    def headers
      transport == "http" ? data["headers"] || {} : {}
    end
    # @endgroup

    ##
    # @return [Array<Class<LLM::Tool>>]
    #  Returns the cached MCP tool classes
    def tools
      @tools ||= mcp.tools
    end

    ##
    # @return [void]
    #  Starts the MCP client
    def start
      mcp.start
    end

    ##
    # @return [void]
    #  Stops the MCP client
    def stop
      mcp.stop
    end

    private

    def before_validation
      super
      self[:data] = self.class.dump_data(self[:data]) unless String === self[:data]
    end

    def validate
      super
      Relay::Validators::MCP.new(self).call
    end

    ##
    # Builds an {LLM::MCP} instance from the persisted transport settings.
    #
    # For `http` transports this returns an HTTP-backed MCP client using
    # {#url} and {#headers}. For `stdio` transports it returns a stdio-backed
    # MCP client using {#argv}, {#env}, and {#cwd}.
    #
    # @return [LLM::MCP]
    def mcp
      @mcp ||= if transport == "http"
        LLM::MCP.http(url:, headers:)
      else
        LLM::MCP.stdio(argv:, env:, cwd: cwd.empty? ? nil : cwd)
      end
    end
  end
end
