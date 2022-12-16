require 'open-uri'
require 'nokogiri'

module LPVScraper
  module Contao
    class Extractor
      def call(url)
        url
          .then { URI.open(_1) }
          .read
          .then { Nokogiri::HTML5(_1) }
      end

      def to_proc
        method(:call).to_proc
      end
    end
  end
end
