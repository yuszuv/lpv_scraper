# frozen_string_literal: true

require "dry/types"

module LPVScraper
  ISO8601_REGEXP = /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\+\d{2}:\d{2}/
  CONCAT_URLS_REGEXP = /^(?:(?<link>#{URI::DEFAULT_PARSER.make_regexp})\|\|)*\g<link>$|^$/

  Types = Dry.Types

  module Types
    # Define your custom types here
    ISO8601 = String.constrained(format: ISO8601_REGEXP)
    ImportUrls = String.constrained(format: CONCAT_URLS_REGEXP)
    HTML = Constructor(String) do |values|
      doc = Nokogiri::HTML5.fragment(values, max_errors: -1)
      doc.errors.any? ? nil : doc.to_s
    end
  end
end
