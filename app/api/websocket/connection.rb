# frozen_string_literal: true

class API::Websocket
  module Connection
    def on_connect(conn, llm, sess)
      write(conn, event: "welcome", provider: llm.class.to_s, model: sess.model)
      while (message = conn.read)
        read(conn, sess, message)
      end
    end

    def write(conn, message)
      conn.write(message.to_json)
      conn.flush
    end

    def read(conn, sess, message)
      write(conn, event: "status", message: "Thinking…")
      if sess.messages.empty?
        sess.talk initial_prompt(message)
      else
        sess.talk(message.buffer)
      end
      while sess.functions.any?
        functions = sess.functions
        write(conn, event: "status", message: tool_status(functions))
        sess.talk functions.map(&:call)
      end
      write(conn, event: "status", message: "Done")
      write(conn, event: "done", cost: sess.cost.to_s)
    rescue LLM::NoSuchModelError
      write(conn, event: "done", cost: "unknown")
    rescue StandardError => e
      pp e, e.message, e.backtrace
      write(conn, event: "status", message: "Error")
      write(conn, event: "error")
    end
  end
end
