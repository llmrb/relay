# frozen_string_literal: true

class Relay::Routes::Websocket
  module Interrupt
    def interrupt?(payload)
      payload["type"] == "interrupt"
    end

    def interrupt!(conn, ctx)
      return unless request_in_flight?
      ctx.interrupt!
      write(conn, fragment(:status, status_bar(status: "Cancelling...", ctx:)))
    end

    def on_interrupt(conn, ctx)
      message = vars[:messages].reverse_each.find { _1[:role] == :assistant }
      if message && message[:content].to_s.empty?
        message[:content] = "Request cancelled."
        write(conn, fragment(:replace_last_message, message:))
      end
      write(conn, fragment(:status, status_bar(status: "Request cancelled", ctx:)))
      write(conn, fragment(:input))
    end
  end
end
