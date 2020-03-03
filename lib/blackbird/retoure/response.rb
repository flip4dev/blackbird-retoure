module Blackbird
  module Retoure
    class Response
      attr_reader :label, :qr_code, :shipment_number, :routing_code

      def initialize(json_response)
        payload = JSON.parse(json_response)

        @label = payload['labelData']
        @qr_code = payload['qrLabelData']
        @shipment_number = payload['shipmentNumber']
        @routing_code = payload['routingCode']
      end
    end
  end
end