RSpec.describe Blackbird::Retoure::Connection, vcr: true do
  describe '#new' do
    it 'receives an dhl label' do
      sender_address = ::Blackbird::Retoure::SimpleAddress.new(
        name1: 'Name #1', street_name: 'Street', house_number: '1234', post_code: '12345',
        city: 'German City', country: { country_iso_code: 'DEU' }
      )
      retoure = Blackbird::Retoure::ReturnOrder.new(receiver_id: 'DE', sender_address: sender_address)
      connection = described_class.new

      expect(connection.connect(retoure.to_json)).to be_a Net::HTTPCreated
    end

    it 'does not receive an label due to an error' do
      retoure = Blackbird::Retoure::ReturnOrder.new(receiver_id: 'DE', sender_address: {})
      connection = described_class.new

      expect(connection.connect(retoure.to_json)).to be_a Net::HTTPInternalServerError
    end
  end
end
