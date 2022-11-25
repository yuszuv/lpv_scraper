require 'open-uri'
require 'nokogiri'
require 'dry-schema'

module LPVScraper
  class ScrapeLPV
    include Deps["persistence.rom", "settings", "logger"]

    BASE_URL = "https://lpv-prignitz-ruppin.de"
    NEWS_PAGE_TEMPLATE = "/nachrichtenliste.html?page_n22=%d"

    ARTICLE_SCHEMA = Dry::Schema.define do
      required(:url).filled(:string)
      required(:title).filled(:string)
      required(:subtitle).maybe(:string)
      required(:date).filled(:string)
      required(:author).filled(:string)
      required(:html).filled(:string)
      required(:downloads).array(:hash) do
        required(:url).filled(:string)
        optional(:title).value(:string)
      end
      required(:image_urls).array(:string)
    end

    def call
      (1..5)
        .flat_map(&aggregate_article_links)
        .map(&fetch_article)
        .then(&save_images)
        .then(&persist_articles)
    end

    private

    def aggregate_article_links
      -> (page_number) {
        uri = URI.join(BASE_URL, NEWS_PAGE_TEMPLATE % page_number)
        res = Nokogiri::HTML5(URI.open(uri))

        res.css('.layout_short > h2 > a').map do |link|
          URI.join(
            BASE_URL,
            link["href"]
          )
        end
      }
    end

    def fetch_article
      -> (url) {
        # TODO add logger

        logger.info message: "fetchting url: #{url}"
        doc = Nokogiri::HTML5(url)

        article = doc.at_css('.mod_newsreader')

        # TODO save images etc
        # TODO dry-transformer
        result = ARTICLE_SCHEMA.({
          url: url.to_s,
          title: article.at_css('h1').text,
          subtitle: article.at_css('h2')&.text,
          date: article.at_css('p.info time')["datetime"],
          author: article
            .at_css('p.info').children.last
            .text.gsub(/^\s*von\s*/,'').strip,
          html: article.css('.layout_full > div')
            .map(&:to_s).join.gsub(/>\s+</,"><"),
          downloads: article.css('.enclosure .download-element a')
            .map do |node|
              { title: node["title"],
                url: URI.join(BASE_URL, node["href"]).to_s }
            end,
            image_urls: article.css('div .image_container a').map{ |node| URI.join(BASE_URL, node["href"]).to_s },
        })

        if result.success?
          result.to_h
        else 
          raise result.errors.to_h.to_s
        end
      }
    end

    def save_images
      -> (arr) {
        arr.each do |article|
          article[:image_urls].each do |url|
            fs = Dry::Files.new

            base_path = settings.image_directory
            logger.info message: "saving image #{url} ..."
            file = URI.open(url).read

            output_path = fs.join(base_path, File.basename(url))

            fs.write(output_path, file)
          end
        end
      }
    end

    def persist_articles
      -> (arr) {
        arr.each do |article|
          cmd = rom.relations[:articles].command(:create, result: :one)
          cmd.(**article)
        end
      }
    end
  end
end
