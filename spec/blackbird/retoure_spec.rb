RSpec.describe Blackbird::Retoure do
  it 'has a version number' do
    expect(Blackbird::Retoure::VERSION).not_to be nil
  end

  describe 'create a DHL retoure label' do
    it 'only a shipping label' do
      label_response = described_class.retoure_label(
        receiver_id: 'DE',
        sender_address: {
          name1: 'Name #1',
          street_name: 'Street Name',
          house_number: 'House Number #',
          post_code: 'Post Code',
          city: 'City'
        }
      )

      expect(label_response).to be_a(::Blackbird::Retoure::Response)
    end

    it 'raises an Blackbird::Retoure::InvalidData exception as some data is invalid' do
      expect do
        described_class.retoure_label(
          receiver_id: 'DE',
          sender_address: {
            name1: 'Name #1',
            street_name: 'Street Name',
            house_number: 'House Number #',
            city: 'City'
          }
        )
      end.to raise_error(::Blackbird::Retoure::InvalidDataError)
    end
  end
end
