# frozen_string_literal: true

require "cgi"
require "uri"

module Relay
  class Jukebox
    def load
      Relay::Models::Song.order(:id).map { entry(_1) }
    end

    def normalize_track(url)
      uri = URI.parse(url.to_s.strip)
      host = uri.host.to_s.downcase
      video_id =
        case host
        when "youtu.be"
          uri.path.split("/").reject(&:empty?).first
        when "youtube.com", "www.youtube.com", "m.youtube.com",
             "youtube-nocookie.com", "www.youtube-nocookie.com"
          extract_youtube_id(uri)
        end
      raise ArgumentError, "unsupported YouTube URL" if video_id.to_s.empty?
      "https://www.youtube-nocookie.com/embed/#{video_id}"
    rescue URI::InvalidURIError
      raise ArgumentError, "invalid YouTube URL"
    end

    def remove(name: nil, title: nil, track: nil)
      normalized_name = name && normalize_text(name)
      normalized_title = title && normalize_text(title)
      normalized_track = track && normalize_track(track)
      raise ArgumentError, "name, title, or track is required" unless [normalized_name, normalized_title, normalized_track].any?
      removed = []
      songs.each do |song|
        entry = entry(song)
        matched = true
        matched &&= normalize_text(entry["name"]) == normalized_name if normalized_name
        matched &&= normalize_text(entry["title"]) == normalized_title if normalized_title
        matched &&= normalize_track(entry["track"]) == normalized_track if normalized_track
        next unless matched
        removed << entry
        song.delete
      end
      {removed: removed.length, entries: removed}
    end

    def add(name:, title:, track:)
      normalized_track = normalize_track(track)
      entry = {"name" => scrub_text(name), "title" => scrub_text(title), "track" => normalized_track}
      raise ArgumentError, "name is required" if entry["name"].empty?
      raise ArgumentError, "title is required" if entry["title"].empty?
      songs.each do |song|
        existing = entry(song)
        song.delete if same_track?(existing, entry) || same_song?(existing, entry)
      end
      Relay::Models::Song.create(**entry.transform_keys(&:to_sym))
      entry
    end

    private

    def extract_youtube_id(uri)
      path = uri.path.to_s
      return path.split("/").reject(&:empty?).last if path.start_with?("/embed/", "/shorts/")
      CGI.parse(uri.query.to_s).fetch("v", []).first
    end

    def songs
      Relay::Models::Song.order(:id).all
    end

    def same_track?(left, right)
      normalize_track(left["track"]) == normalize_track(right["track"])
    rescue ArgumentError
      false
    end

    def same_song?(left, right)
      normalize_text(left["name"]) == normalize_text(right["name"]) &&
        normalize_text(left["title"]) == normalize_text(right["title"])
    end

    def scrub_text(value)
      value.to_s.strip.gsub(/\s+/, " ")
    end

    def normalize_text(value)
      scrub_text(value).downcase
    end

    def entry(song)
      {"name" => song.name, "title" => song.title, "track" => normalize_track(song.track)}
    end
  end
end
