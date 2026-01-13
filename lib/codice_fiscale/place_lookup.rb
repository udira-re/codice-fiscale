# frozen_string_literal: true

require "json"

module CodiceFiscale
  # Module to look up Italian and foreign place codes for CF generation
  module PlaceLookup
    DATA_PATH = File.join(__dir__, "data", "places.json")
    PLACE_DATA = JSON.parse(File.read(DATA_PATH)).freeze

    def self.find(str)
      return nil if str.nil? || str.strip.empty?

      normalized = str.upcase.strip
      place = PLACE_DATA.find do |p|
        p["name"].upcase == normalized || p["code"].upcase == normalized
      end
      place&.dig("code")
    end
  end
end
