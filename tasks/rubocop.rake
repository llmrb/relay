# frozen_string_literal: true

desc "Run rubocop"
task :rubocop do
  sh "bundle exec rubocop"
end

namespace :rubocop do
  desc "Run rubocop auto-correct"
  task :fix do
    sh "bundle exec rubocop -A"
  end
end
