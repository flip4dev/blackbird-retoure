RSpec.describe Blackbird::Retoure::SimpleAddress do
  describe '#new' do
    it 'sets the given fields' do
      address = described_class.new(
        name1: 'Name #1',
        name2: 'Name #2',
        name3: 'Name #3',
        street_name: 'Street',
        house_number: 'House Number #',
        post_code: 'Post Code #',
        city: 'City'
      )

      expect(address.name1).to eq 'Name #1'
      expect(address.name2).to eq 'Name #2'
      expect(address.name3).to eq 'Name #3'
      expect(address.street_name).to eq 'Street'
      expect(address.house_number).to eq 'House Number #'
      expect(address.post_code).to eq 'Post Code #'
      expect(address.city).to eq 'City'
    end

    it 'sets also the country' do
      address = described_class.new(
        name1: 'Name #1',
        name2: 'Name #2',
        name3: 'Name #3',
        street_name: 'Street',
        house_number: 'House Number #',
        post_code: 'Post Code #',
        city: 'City',
        country: { country_iso_code: 'DEU' }
      )

      expect(address.name1).to eq 'Name #1'
      expect(address.name2).to eq 'Name #2'
      expect(address.name3).to eq 'Name #3'
      expect(address.street_name).to eq 'Street'
      expect(address.house_number).to eq 'House Number #'
      expect(address.post_code).to eq 'Post Code #'
      expect(address.city).to eq 'City'
      expect(address.country).to be_a ::Blackbird::Retoure::Country
      expect(address.country.country_iso_code).to eq 'DEU'
    end
  end

  describe '#country=' do
    it 'instantiates a new country object' do
      address = described_class.new
      address.country = { country_iso_code: 'DEU' }

      expect(address.country).to be_a(::Blackbird::Retoure::Country)
      expect(address.country.country_iso_code).to eq 'DEU'
    end

    it 'can also attach an already existing object' do
      country = Blackbird::Retoure::Country.new(country_iso_code: 'DEU')
      address = described_class.new
      address.country = country

      expect(address.country).to be_a ::Blackbird::Retoure::Country
      expect(address.country.country_iso_code).to eq 'DEU'
    end
  end

  describe '#valid?' do
    it 'is only valid when certain fields are set' do
      address = described_class.new(
        name1: 'Name #1', street_name: 'Street Name', house_number: 'House Number #', post_code: 'Post Code',
        city: 'City'
      )
      expect(address).to be_valid
    end

    it 'is invalid as required fields are not set' do
      address = described_class.new

      address.name1 = 'Name #1'
      expect(address).not_to be_valid

      address.street_name = 'Street Name'
      expect(address).not_to be_valid

      address.house_number = 'House #'
      expect(address).not_to be_valid

      address.post_code = 'Post Code'
      expect(address).not_to be_valid

      address.city = 'City'
      expect(address).to be_valid
    end

    it 'is invalid as the country object is invalid' do
      address = described_class.new(
        name1: 'Name #1', street_name: 'Street Name', house_number: 'House Number #', post_code: 'Post Code',
        city: 'City'
      )
      expect(address).to be_valid

      address.country = { country_iso_code: 'DE' }
      expect(address).not_to be_valid
    end
  end

  describe '#to_json' do
    it 'creates a json payload' do
      address = described_class.new(
        name1: 'Name #1', street_name: 'Street Name', house_number: 'House Number #', post_code: 'Post Code',
        city: 'City'
      )
      address.country = { country_iso_code: 'DEU' }

      expect(address.to_json).to eq(
        {
          name1: 'Name #1', streetName: 'Street Name', houseNumber: 'House Number #',
          postCode: 'Post Code', city: 'City', country: { countryISOCode: 'DEU' }
        }.to_json
      )
    end
  end
end
