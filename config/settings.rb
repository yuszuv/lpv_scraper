# frozen_string_literal: true

module LPVScraper
  class Settings < Hanami::Settings
    setting :csv_file, constructor: Types::String
    setting :base_url, constructor: Types::String
    setting :news_path, constructor: Types::String
    
    def image_directory
      File.expand_path("../images/", csv_file)
    end
  end
end
