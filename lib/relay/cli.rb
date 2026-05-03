# frozen_string_literal: true

require "optparse"

module Relay
  class CLI
    DEFAULT_BIND = "http://0.0.0.0:9292"

    def self.start(argv = ARGV)
      new(argv).start
    end

    def initialize(argv)
      @argv = argv.dup
    end

    def start
      command = argv.shift
      case command
      when "start"
        start_server(argv)
      else
        warn usage
        exit(command ? 1 : 0)
      end
    end

    private

    attr_reader :argv

    def start_server(argv)
      bind = DEFAULT_BIND
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: relay start [--bind URL]"
        opts.on("--bind URL", "Bind Falcon to a URL") { bind = _1 }
      end
      parser.parse!(argv)
      exec "falcon", "serve", "--bind", bind
    end

    def usage
      <<~TEXT
        Usage: relay start [--bind URL]
      TEXT
    end
  end
end
