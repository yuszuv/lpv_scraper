# frozen_string_literal: true

require "hanami/rake_tasks"

desc "scrape da lpv"
task :scrape => :environment do
  app = Hanami.app
  csv_file = app["settings"].csv_file
  fs = Dry::Files.new
  fs.delete(csv_file)
  fs.touch(csv_file)
  app["contao_scraper"].(pages: (1..5))
end

require "rom/sql/rake_task"

task :environment do
  require_relative "config/app"
  require "hanami/prepare"
end

namespace :db do
  task setup: :environment do
    Hanami.app.prepare(:persistence)
    ROM::SQL::RakeSupport.env = Hanami.app["persistence.config"]
  end
end


