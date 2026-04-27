# frozen_string_literal: true

module Relay::Models
  module MCP::DataNormalizer
    def normalize_data(transport, data)
      data = load_data(data)
      return {} unless data.is_a?(Hash)

      case transport
      when "http"
        normalize_http_data(data)
      else
        normalize_stdio_data(data)
      end
    end

    private

    def normalize_http_data(data)
      {
        "url" => normalize_url(data["url"]),
        "headers" => Array(data["headers"]).each_with_object({}) do |line, headers|
          key, value = line.to_s.strip.split("=", 2)
          headers[key] = value.to_s if key && !key.empty?
        end
      }.delete_if { |_, value| value.respond_to?(:empty?) && value.empty? }
    end

    def normalize_stdio_data(data)
      argv = if data["command"]
        [
          data["command"],
          *Array(data["arguments"])
        ]
      else
        Array(data["argv"])
      end

      {
        "argv" => argv.map(&:to_s).map(&:strip).reject(&:empty?),
        "cwd" => data["cwd"].to_s.strip,
        "env" => Array(data["env"]).each_with_object({}) do |line, env|
          key, value = line.to_s.strip.split("=", 2)
          env[key] = value.to_s if key && !key.empty?
        end
      }.delete_if { |_, value| value.respond_to?(:empty?) && value.empty? }
    end
  end
end
