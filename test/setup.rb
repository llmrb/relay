# frozen_string_literal: true

require "test/unit"
require "rack/test"

ENV["RACK_ENV"] = "test"

require_relative "../app/init"
