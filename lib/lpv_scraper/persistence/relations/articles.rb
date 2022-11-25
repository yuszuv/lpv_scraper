module LPVScraper
  module Persistence
    module Relations
      class Articles < ROM::Relation[:csv]
        schema(:articles, infer: true)
      end
    end
  end
end
