# frozen_string_literal: true

require 'date'

module CodiceFiscale
  # Generator class to create Italian and foreign Codice Fiscale codes
  # based on personal information such as name, date of birth, gender,
  # and place of birth.
  class Generator
    MONTH_CODES = {
      1 => 'A', 2 => 'B', 3 => 'C', 4 => 'D', 5 => 'E', 6 => 'H',
      7 => 'L', 8 => 'M', 9 => 'P', 10 => 'R', 11 => 'S', 12 => 'T'
    }.freeze

    ODD_TABLE = {
      '0' => 1, '1' => 0, '2' => 5, '3' => 7, '4' => 9,
      '5' => 13, '6' => 15, '7' => 17, '8' => 19, '9' => 21,
      'A' => 1, 'B' => 0, 'C' => 5, 'D' => 7, 'E' => 9,
      'F' => 13, 'G' => 15, 'H' => 17, 'I' => 19, 'J' => 21,
      'K' => 2, 'L' => 4, 'M' => 18, 'N' => 20, 'O' => 11,
      'P' => 3, 'Q' => 6, 'R' => 8, 'S' => 12, 'T' => 14,
      'U' => 16, 'V' => 10, 'W' => 22, 'X' => 25, 'Y' => 24, 'Z' => 23
    }.freeze

    EVEN_TABLE = {
      '0' => 0, '1' => 1, '2' => 2, '3' => 3, '4' => 4,
      '5' => 5, '6' => 6, '7' => 7, '8' => 8, '9' => 9,
      'A' => 0, 'B' => 1, 'C' => 2, 'D' => 3, 'E' => 4,
      'F' => 5, 'G' => 6, 'H' => 7, 'I' => 8, 'J' => 9,
      'K' => 10, 'L' => 11, 'M' => 12, 'N' => 13, 'O' => 14,
      'P' => 15, 'Q' => 16, 'R' => 17, 'S' => 18, 'T' => 19,
      'U' => 20, 'V' => 21, 'W' => 22, 'X' => 23, 'Y' => 24, 'Z' => 25
    }.freeze

    def initialize(params)
      @first_name = params[:first_name].upcase.strip
      @last_name  = params[:last_name].upcase.strip
      @gender     = params[:gender].upcase.strip
      @date_of_birth = params[:date_of_birth]
      @place_of_birth = params[:place_of_birth].upcase.strip
    end

    def generate
      cf = surname_code + name_code + date_code + place_code
      cf + control_character(cf)
    end

    def formatted
      raw = generate
      "#{raw[0, 3]} #{raw[3, 3]} #{raw[6, 5]} #{raw[11, 4]} #{raw[15]}"
    end

    private

    def surname_code
      code_letters(@last_name)
    end

    def name_code
      consonants = @first_name.gsub(/[^BCDFGHJKLMNPQRSTVWXYZ]/, '').chars
      vowels = @first_name.gsub(/[^AEIOU]/, '').chars
      letters = consonants.size >= 4 ? consonants[0] + consonants[2] + consonants[3] : consonants.join
      (letters + vowels.join)[0, 3].ljust(3, 'X')
    end

    def code_letters(name)
      consonants = name.gsub(/[^BCDFGHJKLMNPQRSTVWXYZ]/, '')
      vowels = name.gsub(/[^AEIOU]/, '')
      (consonants + vowels)[0, 3].ljust(3, 'X')
    end

    def date_code
      year = @date_of_birth.year.to_s[-2..]
      month = MONTH_CODES[@date_of_birth.month]
      day = @gender == 'F' ? (@date_of_birth.day + 40).to_s.rjust(2, '0') : @date_of_birth.day.to_s.rjust(2, '0')
      "#{year}#{month}#{day}"
    end

    def place_code
      code = CodiceFiscale::PlaceLookup.find(@place_of_birth)
      raise CodiceFiscale::Error, "Unknown place #{@place_of_birth}" unless code

      code
    end

    # Computes the control character of a CF
    def control_character(cf_first)
      total = cf_first.chars.each_with_index.reduce(0) do |sum, (c, idx)|
        sum + (idx.even? ? ODD_TABLE[c] : EVEN_TABLE[c])
      end
      ('A'.ord + (total % 26)).chr
    end
  end
end
