#!/usr/bin/env ruby
require_relative "../app/init"
require "yaml"

Relay::Models::User.create(
  name: "0x1eef",
  email: "0x1eef@hardenedbsd.org",
  password: "relay"
)

if Relay::Models::Song.count.zero?
  YAML.safe_load_file(File.join(Relay.resources_dir, "jukebox.yml"), permitted_classes: [], aliases: false).each do |entry|
    Relay::Models::Song.create(
      name: entry["name"],
      title: entry["title"],
      track: entry["track"]
    )
  end
end
