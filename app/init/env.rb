# frozen_string_literal: true

env = Relay.env_path
if File.readable?(env)
  data = File.read(env)
  lines = data.each_line
  lines.each do |line|
    k, v = line.split("=")
    ENV[k] = v.chomp
  end
end
