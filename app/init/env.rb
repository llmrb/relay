# frozen_string_literal: true

require "fileutils"
require "securerandom"

env = Relay.env_path
if File.readable?(env)
  data = File.read(env)
  lines = data.each_line
  lines.each do |line|
    k, v = line.split("=")
    ENV[k] = v.chomp
  end
end

if ENV["SESSION_SECRET"].to_s.empty?
  FileUtils.mkdir_p Relay.home
  ENV["SESSION_SECRET"] = SecureRandom.hex(64)
  File.write(env, "", mode: "a") unless File.exist?(env)
  File.write(env, "SESSION_SECRET=#{ENV["SESSION_SECRET"]}\n", mode: "a")
end
