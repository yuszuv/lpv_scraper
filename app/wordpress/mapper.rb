require 'babosa'

module LPVScraper
  module Wordpress
    class Mapper
      include Deps["inflector", "settings"]

      HREF_REGEXP = /(?<=href=")(\S+?)(?=")/
      SRC_REGEXP = /(?<=src=")(\S+?)(?=")/

      def call(html)
        {
          author: extract_author(html),
          content: extract_html(html),
          excerpt: extract_excerpt(html),
          title: extract_title(html),
          published_at: extract_published_at(html),
          slug: extract_slug(html),
          attachment_urls: extract_attachments(html),
          image_urls: extract_image_urls(html),
        }
      end

      def to_proc
        method(:call).to_proc
      end

      private

      def extract_title(article)
        article.at_css('h1')&.text || ""
      end

      def extract_excerpt(article)
        article.at_css('.layout_full > div > p')&.to_html || ""
      end

      def extract_html(article)

        article
          .css('.layout_full > div')
          .map(&:to_s)
          .join
          .gsub(/>\s+</,"><")
          .gsub(/\n/,'')
          .gsub(HREF_REGEXP) { |m| URI::DEFAULT_PARSER.make_regexp.match(m) ? m : URI.join(settings.base_url, m) }
          .gsub(SRC_REGEXP) { |m| URI::DEFAULT_PARSER.make_regexp.match(m) ? m : URI.join(settings.base_url, m) }
      end

      def extract_author(article)
        article
          .at_css('p.info')
          .children
          .last
          &.text.to_s
          .gsub(/^\s*von\s*/,'')
          .strip
      end

      def extract_published_at(article)
        str = article.at_css('p.info time')&.[]("datetime")
        Time.parse(str).iso8601
      end

      def extract_slug(article)
        article
          .then(&method(:extract_title))
          .to_slug
          .normalize(transliterate: :german)
          .to_s
      end

      def extract_attachments(article)
        article
          .css('.enclosure .download-element a')
          .map { URI.join(settings.base_url, _1["href"]).to_s }
          .join("||")
      end

      def extract_image_urls(article)
        article
          .css('div .image_container a')
          .map{ URI.join(settings.base_url, _1["href"]).to_s }
          .join("||")
      end
    end
  end
end
