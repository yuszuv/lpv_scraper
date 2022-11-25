# frozen_string_literal: true

module LPVScraper
  class Settings < Hanami::Settings
    # Define your app settings here, for example:
    #
    # setting :my_flag, default: false, constructor: Types::Params::Bool

    setting :csv_file, constructor: Types::String
  end
end
