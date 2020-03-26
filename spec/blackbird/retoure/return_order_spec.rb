RSpec.describe Blackbird::Retoure::ReturnOrder do
  describe '#new' do
    it 'sets the given fields' do
      return_order = described_class.new(
        receiver_id: 'DE',
        customer_reference: 'Customer Reference',
        shipment_reference: 'Shipment Reference',
        email: 'e@mail.com',
        telephone_number: '0123456789',
        weight_in_grams: 400,
        value: 123.45
      )

      expect(return_order.receiver_id).to eq 'DE'
      expect(return_order.customer_reference).to eq 'Customer Reference'
      expect(return_order.shipment_reference).to eq 'Shipment Reference'
      expect(return_order.email).to eq 'e@mail.com'
      expect(return_order.telephone_number).to eq '0123456789'
      expect(return_order.weight_in_grams).to eq 400
      expect(return_order.value).to eq 123.45
      expect(return_order.return_document_type).to eq 'SHIPMENT_LABEL'
    end

    it 'also sets the sender address and country' do
      return_order = described_class.new(
        receiver_id: 'DE',
        customer_reference: 'Customer Reference',
        shipment_reference: 'Shipment Reference',
        email: 'e@mail.com',
        telephone_number: '0123456789',
        weight_in_grams: 400,
        value: 123.45,
        sender_address: {
          name1: 'Name 1',
          street_name: 'Street Name',
          house_number: '12345',
          post_code: 'Post Code',
          city: 'City',
          country: {
            country_iso_code: 'DEU'
          }
        }
      )

      expect(return_order.receiver_id).to eq 'DE'
      expect(return_order.customer_reference).to eq 'Customer Reference'
      expect(return_order.shipment_reference).to eq 'Shipment Reference'
      expect(return_order.email).to eq 'e@mail.com'
      expect(return_order.telephone_number).to eq '0123456789'
      expect(return_order.weight_in_grams).to eq 400
      expect(return_order.value).to eq 123.45
      expect(return_order.sender_address).to be_a Blackbird::Retoure::SimpleAddress
      expect(return_order.sender_address.name1).to eq 'Name 1'
      expect(return_order.sender_address.country).to be_a Blackbird::Retoure::Country
      expect(return_order.sender_address.country.country_iso_code).to eq 'DEU'
    end
  end

  describe '#sender_address=' do
    it 'instantiates a new SimpleAddress object' do
      return_order = described_class.new
      return_order.sender_address = {
        name1: 'Name 1',
        street_name: 'Street Name',
        house_number: 'House Number',
        post_code: 'Post Code',
        city: 'City'
      }

      expect(return_order.sender_address).to be_a Blackbird::Retoure::SimpleAddress
      expect(return_order.sender_address.name1).to eq 'Name 1'
      expect(return_order.sender_address.street_name).to eq 'Street Name'
    end

    it 'attaches an already existing object' do
      address = Blackbird::Retoure::SimpleAddress.new(name1: 'Name 12345')
      return_order = described_class.new
      return_order.sender_address = address
      expect(return_order.sender_address).to be_a Blackbird::Retoure::SimpleAddress
      expect(return_order.sender_address.name1).to eq 'Name 12345'
    end
  end

  describe '#valid?' do
    it 'is only valid when specific fields are set' do
      return_order = described_class.new
      expect(return_order).to be_invalid

      return_order.instance_variable_set(:@receiver_id, 'abcde')
      expect(return_order).to be_invalid

      return_order.sender_address = {
        name1: 'Name #1', street_name: 'Street Name', house_number: '12345', post_code: 'Post Code',
        city: 'City', country: { country_iso_code: 'DEU' }
      }
      expect(return_order).to be_valid
    end

    it 'is invalid if the sender_address object is invalid too' do
      sender_address = ::Blackbird::Retoure::SimpleAddress.new(
        name1: 'name 1', street_name: 'Street Name', house_number: '12345', city: 'City'
      )
      return_order = described_class.new(receiver_id: 'abcdef', sender_address: sender_address)
      expect(return_order).to be_invalid
      expect(return_order.sender_address.errors.size).to eq 3
    end
  end

  describe '#to_json' do
    it 'creates a json payload' do
      sender_address = ::Blackbird::Retoure::SimpleAddress.new(
        name1: 'Name #1', street_name: 'Street Name', house_number: '12345', post_code: 'Post Code',
        city: 'City'
      )
      sender_address.country = { country_iso_code: 'DEU' }
      return_order = described_class.new(receiver_id: 'DE', sender_address: sender_address)

      expect(return_order.to_json).to eq({ receiverId: 'DE', senderAddress: { name1: 'Name #1',
                                                                              streetName: 'Street Name',
                                                                              houseNumber: '12345',
                                                                              postCode: 'Post Code', city: 'City',
                                                                              country: { countryISOCode: 'DEU' } },
                                           returnDocumentType: 'SHIPMENT_LABEL' }.to_json)
    end
  end
end
