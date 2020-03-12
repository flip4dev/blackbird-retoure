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

  describe 'private methods' do
    context '#authentication_data' do
      it 'returns the username and password in the sandbox environment' do
        expect(described_class.new.send(:authentication_data, 'sandbox')).to eq [
          ::Blackbird::Retoure.configuration.username,
          ::Blackbird::Retoure.configuration.password
        ]
      end

      it 'returns the username and password in the production environment' do
        expect(described_class.new.send(:authentication_data, :production)).to eq [
          ::Blackbird::Retoure.configuration.app_id,
          ::Blackbird::Retoure.configuration.app_token
        ]
      end
    end

    context '#dpdhl_token' do
      it 'returns the token for the sandbox environment' do
        expect(described_class.new.send(:dpdhl_token, 'sandbox')).to eq described_class::SANDBOX_DPDHL_TOKEN
      end

      it 'creates the correct token for the production environment' do
        connection = described_class.new
        connection.instance_variable_set(:@username, 'username')
        connection.instance_variable_set(:@password, 'password')

        expect(connection.send(:dpdhl_token, :production)).to eq 'dXNlcm5hbWU6cGFzc3dvcmQ='
      end
    end
  end
end