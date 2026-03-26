# frozen_string_literal: true

task :test do
  require "test/unit"
  require "test/unit/ui/console/testrunner"

  test_files = Dir["test/**/*_test.rb"]
  if test_files.empty?
    puts "No tests found."
  else
    test_files.each { |file| require File.expand_path(file) }
  end
end
