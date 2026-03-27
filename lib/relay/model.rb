# frozen_string_literal: true

module Relay
  module Model
    def self.included(model)
      model.plugin :timestamps
    end
  end
end