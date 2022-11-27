require 'open-uri'
require 'nokogiri'

module LPVScraper
  module Contao
    class Extractor
      def call(url)
        url
          .then(&URI.method(:open))
          .read
          .then{ Nokogiri::HTML5(_1) }
      end

      def to_proc
        -> (url) { call(url) }
      end
    end
  end
end
