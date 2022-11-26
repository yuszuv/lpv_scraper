require 'open-uri'
require 'nokogiri'
require 'dry-schema'

module LPVScraper
  class ContaoScraper
    include Deps[
      "persistence.rom",
      "settings",
      "logger",
      "contao_spider",
      "wordpress_mapper",
      fetch_html: "contao_extractor",
      validate: "wordpress_validator",
      repo: "articles_repo",
    ]

    def call(...)
      expand_urls(...)
        .flat_map(&fetch_html)
        .flat_map(&extract_links)
        .map(&fetch_html)
        .map(&wordpress_mapper)
        .map(&validate)
        # .then(&save_images)
        .map(&persist)
    end

    private

    def expand_urls(url: settings.base_url, path: settings.news_path, pages: [""])
      pages.map { URI(url % [path, _1]) }
    end

    def extract_links
      -> (html) { contao_spider.(html).map(&:itself) }
    end

    def persist
      -> (result) {
        if result.success?
          repo.create(result.to_h)
        else
          logger.error errors: result.errors.to_h
        end
      }
    end

    # TODO save images and attachments
    def save_images
      -> (arr) {
        arr.each do |article|
          article[:image_urls].each do |url|
            fs = Dry::Files.new
            base_path = settings.image_directory
            output_path = fs.join(base_path, File.basename(url))

            logger.info message: "saving image #{url} ..."
            file = URI.open(url).read

            fs.write(output_path, file)
          end
        end
      }
    end
  end
end
