# frozen_string_literal: true

require "hanami"

module LPVScraper
  class App < Hanami::App
    config.inflections do |inflections|
      inflections.acronym "LPV"
    end
  end
end
