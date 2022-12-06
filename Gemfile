# frozen_string_literal: true

source "https://rubygems.org"

gem "hanami", "~> 2.0"

gem "dry-types", "~> 1.0", ">= 1.6.1"
gem "dry-schema"
gem "puma"
gem "rake"
gem "rack"

gem "rom", "~> 5.3"
gem "rom-csv", github: "yuszuv/rom-csv", branch: "master"

gem "nokogiri"
gem "babosa"

group :development, :test do
  gem "dotenv"
  gem "byebug"
end

group :cli, :development do
  gem "hanami-reloader"
end

group :cli, :development, :test do
  gem "hanami-rspec"
end

group :development do
  gem "guard-puma", "~> 0.8"
end

group :test do
  gem "webmock"
end
