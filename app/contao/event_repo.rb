module LPVScraper
  module Contao
    class EventRepo < ROM::Repository[:events]
      include Deps[container: "persistence.rom"]

      def list
        events
          .order(:tstamp)
          .combine(:tl_content)
          .to_a
      end
    end
  end
end
