module LPVScraper
  module Contao
    class Spider
      include Deps["settings"]

      LINK_SELECTOR = '.layout_short > h2 > a'

      def call(html)
        Enumerator.new do |yielder|
          find_links(html).each do |link|
            yielder << URI.join(
              settings.base_url,
              link["href"]
            )
          end
        end
      end

      private

      def find_links(html)
        html.css(LINK_SELECTOR)
      end
    end
  end
end
