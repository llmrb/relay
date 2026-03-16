# frozen_string_literal: true

dir = File.join(__dir__, "app", "frontend")

desc "Build the frontend"
task build: %i[npm:build]

desc "Serve the website"
task serve: [:build] do
  sh "env $(cat .env) " \
     "bundle exec falcon serve --bind http://0.0.0.0:9292"
end

namespace :npm do
  desc "Build the frontend"
  task build: %i[npm:i] do
    Dir.chdir(dir) do
      sh "npx webpack build"
    end
  end

  desc "Run 'npm install'"
  task :i do
    Dir.chdir(dir) do
      sh "npm i"
    end
  end
end
