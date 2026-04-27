# frozen_string_literal: true

module Relay::Models
  class MCP < Sequel::Model
    include Relay::Model
    extend DataNormalizer
    plugin :validation_class_methods

    set_dataset :mcps
    many_to_one :user
    validates_presence_of :user_id, :name, :transport
    validates_inclusion_of :transport, in: %w[stdio http]

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

    def self.normalize_url(value)
      url = value.to_s.strip
      return "" if url.empty?
      uri = URI.parse(url)
      uri.path = "/" if uri.path.to_s.empty?
      uri.to_s
    rescue URI::InvalidURIError
      url
    end

    def before_validation
      super
      self[:data] = self.class.dump_data(self.class.normalize_data(transport, self[:data]))
    end

    def validate
      super
      Relay::Validators::MCPValidator.new(self).call
    end

    def data
      self.class.load_data(self[:data])
    end

    ##
    # @group stdio
    def argv
      payload["argv"] || []
    end

    def command
      argv.first.to_s
    end

    def arguments
      argv.drop(1)
    end

    def env
      payload["env"] || {}
    end

    def cwd
      payload["cwd"].to_s
    end
    # @endgroup

    ##
    # @group HTTP
    def url
      self.class.normalize_url(payload["url"])
    end

    def headers
      payload["headers"] || {}
    end
    # @endgroup

    ##
    # Builds an {LLM::MCP} instance from the persisted transport settings.
    #
    # For `http` transports this returns an HTTP-backed MCP client using
    # {#url} and {#headers}. For `stdio` transports it returns a stdio-backed
    # MCP client using {#argv}, {#env}, and {#cwd}.
    #
    # @return [LLM::MCP]
    def mcp
      case transport
      when "http"
        LLM::MCP.http(url:, headers:)
      else
        LLM::MCP.stdio(argv:, env:, cwd: cwd.empty? ? nil : cwd)
      end
    end

    private

    def payload
      case data
      when Hash then data
      when Array then {"argv" => data}
      else {}
      end
    end
  end
end
