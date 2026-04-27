# frozen_string_literal: true

module Relay::Routes
  class MCP::FormData
    def self.default(transport: "stdio")
      transport = normalize_transport(transport)
      {
        id: nil,
        persisted: false,
        name: "",
        description: "",
        transport:,
        enabled: true,
        command: "",
        arguments: "",
        cwd: "",
        env: "",
        url: "",
        headers: ""
      }
    end

    def self.from_model(mcp)
      {
        id: mcp.id,
        persisted: true,
        name: mcp.name.to_s,
        description: mcp.description.to_s,
        transport: mcp.transport.to_s,
        enabled: !!mcp[:enabled],
        command: mcp.command,
        arguments: mcp.arguments.join("\n"),
        cwd: mcp.cwd,
        env: mcp.env.map { "#{_1}=#{_2}" }.join("\n"),
        url: mcp.url,
        headers: mcp.headers.map { "#{_1}=#{_2}" }.join("\n")
      }
    end

    def self.from_params(params)
      transport = normalize_transport(params["transport"])
      {
        id: params["id"],
        persisted: false,
        name: params["name"].to_s,
        description: params["description"].to_s,
        transport:,
        enabled: params["enabled"] == "1",
        command: params["command"].to_s,
        arguments: params["arguments"].to_s,
        cwd: params["cwd"].to_s,
        env: params["env"].to_s,
        url: params["url"].to_s,
        headers: params["headers"].to_s
      }
    end

    def self.normalize_transport(value)
      value = value.last if Array === value
      %w[stdio http].include?(value.to_s) ? value.to_s : "stdio"
    end

    private_class_method :normalize_transport
  end
end
