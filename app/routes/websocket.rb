# frozen_string_literal: true

module Relay::Routes
  class Websocket < Base
    require_relative "websocket/connection"
    require_relative "websocket/interrupt"
    require_relative "websocket/stream"

    prepend Relay::Hooks::RequireUser

    include Interrupt
    include Connection
    include Relay::Tools

    def call
      Async::WebSocket::Adapters::Rack.open(request.env) do |conn|
        context = ctx
        stream = Relay::Routes::Websocket::Stream.new(conn, self)
        params = {model: context[:model], stream:, tools: []}
        on_connect conn, context.llm, context, params
      end || upgrade_required
    end

    def tool_status(functions)
      names = functions.filter_map(&:name).reject(&:empty?).uniq
      return "Running tools…" if names.empty?
      "Running #{names.join(", ")}…"
    end

    def report_tool_status(conn, tool)
      write(conn, fragment(:status, status_bar(status: tool_status([tool]))))
    end

    private

    def upgrade_required
      response.status = 426
      response["content-type"] = "text/plain"
      response["upgrade"] = "websocket"
      "Expected a WebSocket upgrade request\n"
    end

    def instructions
      File.read File.join(root, "app", "prompts", "system.md")
    end

    def initial_prompt(message)
      LLM::Prompt.new(llm) do
        _1.system instructions
        _1.user(Array === message ? message : message.to_s)
      end
    end

    ##
    # Returns a logging tracer
    # @return [LLM::Tracer]
    def logger(llm)
      filename = format("%s-%s.log", llm.name, Date.today.strftime("%Y-%m-%d"))
      LLM::Tracer::Logger.new(llm, path: File.join(root, "tmp", filename))
    end
  end
end
