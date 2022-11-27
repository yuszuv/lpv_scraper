module LPVScraper
  module Contao
    class Spider
      # TODO move to settings??
      BASE_URL = "https://lpv-prignitz-ruppin.de"

      def call(html)
        Enumerator.new do |yielder|
          html.css('.layout_short > h2 > a').each do |link|
            url = URI.join(
              BASE_URL,
              link["href"]
            )

            yielder << url
          end
        end
      end
    end
  end
end
