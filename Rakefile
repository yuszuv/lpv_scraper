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


