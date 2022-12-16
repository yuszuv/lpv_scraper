module LPVScraper
  module Persistence
    module Relations
      class Events < ROM::Relation[:sql]
        schema(:tl_calendar_events, as: :events, infer: true)

        gateway :legacy
      end
    end
  end
end
