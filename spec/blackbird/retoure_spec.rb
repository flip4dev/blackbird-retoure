RSpec.describe Blackbird::Retoure do
  it 'has a version number' do
    expect(Blackbird::Retoure::VERSION).not_to be nil
  end

  describe 'create a DHL retoure label', vcr: true do
    let(:shipping_data) do
      {
        receiver_id: 'DE',
        sender_address: {
          name1: 'Name #1',
          street_name: 'Street Name',
          house_number: 'House Number #',
          post_code: '12345',
          city: 'City',
          country: { country_iso_code: 'DEU' }
        }
      }
    end

    it 'only a shipping label' do
      label_response = described_class.shipping_label(shipping_data)
      expect(label_response).to be_a Net::HTTPCreated

      received_payload = JSON.parse(label_response.body)
      expect(received_payload).to be_a Hash
      expect(received_payload['labelData']).not_to be_blank
      expect(received_payload['qrLabelData']).to be_blank
    end

    it 'only a qr code' do
      label_response = described_class.qr_code(shipping_data)
      expect(label_response).to be_a Net::HTTPCreated

      received_payload = JSON.parse(label_response.body)
      expect(received_payload).to be_a Hash
      expect(received_payload['labelData']).to be_blank
      expect(received_payload['qrLabelData']).not_to be_blank
    end

    it 'both labels' do
      label_response = described_class.both(shipping_data)
      expect(label_response).to be_a Net::HTTPCreated

      received_payload = JSON.parse(label_response.body)
      expect(received_payload).to be_a Hash
      expect(received_payload['labelData']).not_to be_blank
      expect(received_payload['qrLabelData']).not_to be_blank
    end

    it 'raises an Blackbird::Retoure::InvalidData exception as some data is invalid' do
      shipping_data[:sender_address].delete(:post_code)

      expect do
        described_class.send(:retrieve_label, shipping_data)
      end.to raise_error(::Blackbird::Retoure::InvalidDataError)
    end
  end
end
