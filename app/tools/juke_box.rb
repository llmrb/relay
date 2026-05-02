# frozen_string_literal: true

module Relay::Tools
  ##
  # Returns the built-in jukebox playlist and embeddable iframe HTML for
  # each track. The playlist is maintained in resources/jukebox.yml.
  class JukeBox < LLM::Tool
    include Relay::Tool

    name "jukebox"
    description "Returns a small built-in playlist of playable music videos"

    ##
    # @return [Array<Hash>]
    def call
      jukebox.load.map do |entry|
        {
          name: entry["name"],
          title: entry["title"],
          track: entry["track"],
          directions: directions,
          html: iframe(entry)
        }
      end
    end

    private

    def jukebox
      @jukebox ||= Relay::Jukebox.new
    end

    def directions
      [
        "Use the list to tell the user what songs are available.",
        "When the user wants to play a specific track, embed that track's iframe HTML exactly as returned.",
        "Do not use `data-play` attributes."
      ]
    end

    def iframe(entry)
      title = ERB::Util.html_escape("#{entry["name"]} - #{entry["title"]}")
      %(<iframe class="h-full w-full" src="#{entry["track"]}" title="#{title}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>)
    end
  end
end
