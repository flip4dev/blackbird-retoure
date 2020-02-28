RSpec.describe Blackbird::Retoure::Country do
  describe '#new' do
    it 'sets the given fields' do
      country = described_class.new(country_iso_code: 'DEU', country: 'Germany', state: 'Hessen')
      expect(country.country_iso_code).to eq 'DEU'
      expect(country.country).to eq 'Germany'
      expect(country.state).to eq 'Hessen'
    end
  end

  describe '#valid?' do
    it 'is invalid as no fields are set' do
      expect(described_class.new()).not_to be_valid
    end

    it 'is invalid as field lengths are not met' do
      expect(described_class.new(country_iso_code: 'DE')).not_to be_valid
      expect(
        described_class.new(country_iso_code: 'DEU', country: 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
      ).not_to be_valid
      expect(
        described_class.new(country_iso_code: 'DEU', state: 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
      ).not_to be_valid
    end

    it 'has only the country_iso_code set and is valid' do
      expect(described_class.new(country_iso_code: 'DEU')).to be_valid
    end

    it 'is valid as the country and state fields are in the correct size' do
      expect(
        described_class.new(
          country_iso_code: 'DEU',
          country: 'abcdefghijklmnopqrstuvwxyz',
          state: 'abcdefghijklmnopqrstuvwxyz'
        )
      ).to be_valid
    end
  end

  describe '#to_json' do
    it 'creates a json payload' do
      country = described_class.new(country_iso_code: 'DEU')
      expect(country.to_json).to eq({ countryISOCode: 'DEU' }.to_json)

      country.country = 'Country'
      expect(country.to_json).to eq({ countryISOCode: 'DEU', country: 'Country' }.to_json)

      country.state = 'State'
      expect(country.to_json).to eq({ countryISOCode: 'DEU', country: 'Country', state: 'State' }.to_json)

      country.country = nil
      expect(country.to_json).to eq({ countryISOCode: 'DEU', state: 'State' }.to_json)
    end
  end
end
