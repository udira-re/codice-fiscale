# frozen_string_literal: true

# spec/codice_fiscale_spec.rb
require 'date'
require 'codice_fiscale'

RSpec.describe CodiceFiscale do
  describe '.generate' do
    it 'generates a valid CF for Italian person' do
      cf = CodiceFiscale.generate(
        first_name: 'Mario',
        last_name: 'Rossi',
        gender: 'M',
        date_of_birth: Date.new(1980, 5, 20),
        place_of_birth: 'ROMA'
      )
      expect(cf).to be_a(String)
      expect(cf.length).to eq(16)
    end
  end

  describe 'Validator' do
    it 'validates a correct CF' do
      cf_generated = CodiceFiscale.generate(
        first_name: 'Mario',
        last_name: 'Rossi',
        gender: 'M',
        date_of_birth: Date.new(1980, 5, 20),
        place_of_birth: 'ROMA'
      )
      expect(CodiceFiscale::Validator.valid?(cf_generated)).to eq(true)
    end

    it 'returns false for an invalid CF' do
      invalid_cf = 'PKHMSH02A41H501X'
      expect(CodiceFiscale::Validator.valid?(invalid_cf)).to eq(false)
    end
  end
end
