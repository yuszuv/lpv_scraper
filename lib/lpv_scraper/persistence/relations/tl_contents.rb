module LPVScraper
  module Persistence
    module Relations
      class TlContents < ROM::Relation[:sql]
        schema(:tl_content, infer: true)

        gateway :legacy

        # for polymorphic assocs
        # see events relations associations
        def view
          where(ptable: "tl_calendar_events")
        end
      end
    end
  end
end

