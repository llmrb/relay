# frozen_string_literal: true

module Relay
  THEME = "dark"

  ##
  # @return [String]
  #  Returns the directory that stores theme stylesheets.
  def self.themes_dir
    @themes_dir ||= File.join(assets_dir, "css", "themes")
  end

  ##
  # @return [String]
  #  Returns the absolute path to the theme stylesheet.
  def self.theme_path
    File.join(themes_dir, "#{THEME}.css")
  end
end
