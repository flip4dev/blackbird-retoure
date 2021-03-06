RSpec.describe Blackbird::Retoure::SimpleAddress do
  describe '#new' do
    it 'sets the given fields' do
      address = described_class.new(
        name1: 'Name #1',
        name2: 'Name #2',
        name3: 'Name #3',
        street_name: 'Street',
        house_number: '12345',
        post_code: 'Post Code',
        city: 'City'
      )

      expect(address.name1).to eq 'Name #1'
      expect(address.name2).to eq 'Name #2'
      expect(address.name3).to eq 'Name #3'
      expect(address.street_name).to eq 'Street'
      expect(address.house_number).to eq '12345'
      expect(address.post_code).to eq 'Post Code'
      expect(address.city).to eq 'City'
    end

    it 'sets also the country' do
      address = described_class.new(
        name1: 'Name #1',
        name2: 'Name #2',
        name3: 'Name #3',
        street_name: 'Street',
        house_number: '12345',
        post_code: 'Post Code',
        city: 'City',
        country: { country_iso_code: 'DEU' }
      )

      expect(address.name1).to eq 'Name #1'
      expect(address.name2).to eq 'Name #2'
      expect(address.name3).to eq 'Name #3'
      expect(address.street_name).to eq 'Street'
      expect(address.house_number).to eq '12345'
      expect(address.post_code).to eq 'Post Code'
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
        name1: 'Name #1', street_name: 'Street Name', house_number: '12345', post_code: 'Post Code',
        city: 'City', country: { country_iso_code: 'DEU' }
      )
      expect(address).to be_valid
    end

    it 'is invalid as required fields are not set' do
      address = described_class.new

      address.instance_variable_set(:@name1, 'Name #1')
      expect(address).not_to be_valid

      address.instance_variable_set(:@street_name, 'Street Name')
      expect(address).not_to be_valid

      address.instance_variable_set(:@house_number, '12345')
      expect(address).not_to be_valid

      address.instance_variable_set(:@post_code, 'Post Code')
      expect(address).not_to be_valid

      address.instance_variable_set(:@city, 'City')
      expect(address).not_to be_valid

      address.country = { country_iso_code: 'DEU' }
      expect(address).to be_valid
    end

    it 'is invalid as the country object is invalid' do
      address = described_class.new(
        name1: 'Name #1', street_name: 'Street Name', house_number: '12345', post_code: 'Post Code',
        city: 'City', country: { country_iso_code: 'DEU' }
      )
      expect(address).to be_valid

      address.country = { country_iso_code: 'DE' }
      expect(address).not_to be_valid
    end

    it 'validates required field lengths' do
      address = described_class.new(
        name1: 'Name #1', street_name: 'Street Name', house_number: '12345', post_code: 'Post Code',
        city: 'City', country: { country_iso_code: 'DEU' }
      )
      expect(address).to be_valid

      %w[@name1 @street_name @city].each do |longer_fields|
        address.instance_variable_set(longer_fields.to_sym, rand(36**40).to_s(36))
        expect(address).not_to be_valid
        # address.send("#{longer_fields}=", rand(36**35).to_s(36))
        address.instance_variable_set(longer_fields.to_sym, rand(36**35).to_s(36))
        expect(address).to be_valid
      end

      address.instance_variable_set(:@house_number, '1234567890')
      expect(address).not_to be_valid
      address.instance_variable_set(:@house_number, '12345')
      expect(address).to be_valid

      address.instance_variable_set(:@post_code, '12345678901234567890')
      expect(address).not_to be_valid
      address.instance_variable_set(:@post_code, '1234512345')
      expect(address).to be_valid
    end

    it 'validates also the length of optional fields' do
      address = described_class.new(
        name1: 'Name #1', street_name: 'Street Name', house_number: '12345', post_code: 'Post Code',
        city: 'City', country: { country_iso_code: 'DEU' }
      )
      expect(address).to be_valid

      %w[@name2 @name3].each do |longer_fields|
        address.instance_variable_set(longer_fields.to_sym, rand(36**40).to_s(36))
        expect(address).not_to be_valid
        address.instance_variable_set(longer_fields.to_sym, '')
        expect(address).to be_valid
      end
    end
  end

  describe '#to_json' do
    it 'creates a json payload' do
      address = described_class.new(
        name1: 'Name #1', street_name: 'Street Name', house_number: '12345', post_code: 'Post Code',
        city: 'City'
      )
      address.country = { country_iso_code: 'DEU' }

      expect(address.to_json).to eq({
        name1: 'Name #1', streetName: 'Street Name', houseNumber: '12345',
        postCode: 'Post Code', city: 'City', country: { countryISOCode: 'DEU' }
      }.to_json)
    end
  end
end
