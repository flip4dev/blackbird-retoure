RSpec.describe Blackbird::Retoure::Response do
  describe '#new' do
    it 'parses a JSON reponse correctly' do
      response = described_class
                 .new(
                   <<JSON
  {
    "shipmentNumber": "999990168640",
    "labelData": "base64 encoded label",
    "qrLabelData": "base64 encoded qr code",
    "routingCode": "40327653113+99000933090010"
  }
JSON
                 )

      expect(response.label).to eq 'base64 encoded label'
      expect(response.qr_code).to eq 'base64 encoded qr code'
      expect(response.shipment_number).to eq '999990168640'
      expect(response.routing_code).to eq '40327653113+99000933090010'
    end
  end
end