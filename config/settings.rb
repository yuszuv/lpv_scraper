# frozen_string_literal: true

module LPVScraper
  class Settings < Hanami::Settings
    # Define your app settings here, for example:
    #
    # setting :my_flag, default: false, constructor: Types::Params::Bool

    setting :csv_file, constructor: Types::String
    
    def image_directory
      File.expand_path("../images/", csv_file)
    end
  end
end
