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
        "headers" => normalize_map(data["headers"])
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
        "env" => normalize_map(data["env"])
      }.delete_if { |_, value| value.respond_to?(:empty?) && value.empty? }
    end

    def normalize_map(value)
      case value
      when Hash
        value.each_with_object({}) do |(key, entry), map|
          key = key.to_s.strip
          next if key.empty?
          map[key] = entry.to_s
        end
      else
        Array(value).each_with_object({}) do |line, map|
          key, entry = line.to_s.strip.split("=", 2)
          map[key] = entry.to_s if key && !key.empty?
        end
      end
    end
  end
end
