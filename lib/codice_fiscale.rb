# frozen_string_literal: true

require_relative "codice_fiscale/version"
require_relative "codice_fiscale/place_lookup"
require_relative "codice_fiscale/generator"
require_relative "codice_fiscale/validator"

module CodiceFiscale
  # Generator class to create Italian and foreign Codice Fiscale codes
  # using personal information like first name, last name, date of birth,
  # gender, and place of birth.
  class Generator
    class Error < StandardError; end

    # Store generated CFs in memory (hash)
    @generated_cfs = {}

    class << self
      # Generate CF and store it
      def generate(params)
        cf = Generator.new(params).generate
        # Key can be anything, e.g., user's full name or a unique ID
        key = "#{params[:first_name].upcase}-#{params[:last_name].upcase}-#{params[:date_of_birth]}"
        @generated_cfs[key] = cf
        cf
      end

      # Get all stored CFs
      def all_generated
        @generated_cfs
      end

      # Validate CF against stored ones
      def validate(code)
        @generated_cfs.value?(code)
      end

      # Formatted CF
      def formatted(params)
        Generator.new(params).formatted
      end
    end
  end
end
