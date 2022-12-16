module LPVScraper
  module Persistence
    module Relations
      class Events < ROM::Relation[:sql]
        schema(:tl_calendar_events, as: :events) do
          attribute :id, Types::Integer
          attribute :tstamp, Types::Integer.constructor(->{ _1.to_i }), read: Types::Time.constructor(Time.method(:at))
          attribute :title, Types::String
          attribute :startDate, Types::Date.optional, alias: :start_date, read: Types::Time.constructor(Time.method(:at))
          attribute :startTime, Types::Time, as: :start_time, read: Types::Time.constructor(Time.method(:at))
          attribute :endTime, Types::Time, as: :end_time, read: Types::Time.constructor(Time.method(:at))
          attribute :endDate, Types::Date.optional, as: :end_date, read: Types::Time.constructor(-> { _1 && Time.at(_1) })
          attribute :location, Types::String
          attribute :teaser, Types::String.optional

          primary_key :id

          associations do
            has_many :tl_content, foreign_key: :pid, view: :view
          end
        end

        gateway :legacy
      end
    end
  end
end
