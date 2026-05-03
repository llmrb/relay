# frozen_string_literal: true

module Relay::Models
  class Song < Sequel::Model
    include Relay::Model
    plugin :validation_class_methods

    set_dataset :songs
    validates_presence_of :name, :title, :track
  end
end
