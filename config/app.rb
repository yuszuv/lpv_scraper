# frozen_string_literal: true

require "hanami"

require 'byebug' if Hanami.env?(:development, :cli, :test)

module LPVScraper
  class App < Hanami::App
    config.inflections do |inflections|
      inflections.acronym "LPV"
    end

    environment(:development) do
      config.logger.options[:colorize] = true
    end
  end
end
