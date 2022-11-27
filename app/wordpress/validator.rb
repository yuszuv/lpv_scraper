require 'dry-schema'

module LPVScraper
  module Wordpress
    class Validator
      ARTICLE_SCHEMA = Dry::Schema.define do
        required(:title).filled(:string)
        required(:excerpt).maybe(:string)
        required(:published_at).filled(Types::ISO8601)
        required(:author).filled(:string)
        required(:content).filled(Types::HTML)
        required(:attachment_urls).maybe(Types::ImportUrls)
        required(:image_urls).maybe(Types::ImportUrls)
      end

      def call(data)
        ARTICLE_SCHEMA.(data)
      end

      def to_proc
        -> { call(_1) }
      end
    end
  end
end
