module Blackbird
  module Retoure
    # Public: This class represents the ReturnOrder object of the DHL API.
    # It validated the required fields for the API like the receiverId,
    # returnDocumentType and the senderAddress.
    #
    # receiver_id = The id of the return receiver.
    # customer_reference = A customer reference number (optional)
    # shipment_reference = Shipment reference (optional)
    # email = E-Mail address of the customer (optional)
    # telephone_number = Telephone number of the customer (optional)
    # weight_in_grams = The weight of the package (optional)
    # value = The value of the goods (optional)
    # return_document_type = The document type. If not provided the
    #   value SHIPMENT_TYPE will be set.
    # sender_address = A Hash or a BlackBird::Retoure::SenderAddress object.
    #
    # Examples
    #
    #   # Create a ReturnOrder object that requests a single shipping label
    #   Blackbird::Retoure::ReturnOrder.new(
    #     receiver_id: 'DE',
    #     sender_address: {
    #       name1: 'Name #1',
    #       street_name: 'Street Name',
    #       house_number: '12345',
    #       post_code: 'Post Code',
    #       city: 'City',
    #       country: {
    #         country_iso_code: 'DEU'
    #       }
    #     }
    #   )
    #   # => <#Blackbird::Retoure::ReturnOrder @receiver_id => 'DE', ...>
    #
    #   # Create just a QR label
    #   sender_address = Blackbird::Retoure::SenderAddress.new(
    #     name1: 'Name #1',
    #     streetName: 'Street Name',
    #     houseNumber: '12345',
    #     postCode: 'Post Code',
    #     city: 'City',
    #     country: {
    #       countryISOCode: 'DEU'
    #     }
    #   )
    #   Blackbird::Retoure::ReturnOrder.new(
    #     receiver_id: 'DE',
    #     senderAddress: sender_address,
    #     return_document_type: 'QR_LABEL'
    #   )
    #   # => <#Blackbird::Retoure::ReturnOrder @receiver_id => 'DE', ...>
    class ReturnOrder
      include ::ActiveModel::Validations

      attr_accessor :receiver_id, :customer_reference, :shipment_reference, :email, :telephone_number,
                    :weight_in_grams, :value, :return_document_type
      attr_reader :sender_address

      validates :receiver_id, :sender_address, presence: true
      validates :return_document_type, inclusion: %w[SHIPMENT_LABEL QR_LABEL BOTH]
      validate :sender_address, :validate_sender_address

      def initialize(args = {})
        @receiver_id = args[:receiver_id]
        @customer_reference = args[:customer_reference]
        @shipment_reference = args[:shipment_reference]
        @email = args[:email]
        @telephone_number = args[:telephone_number]
        @weight_in_grams = args[:weight_in_grams]
        @value = args[:value]
        @return_document_type = args[:return_document_type] || 'SHIPMENT_LABEL'

        self.sender_address = args[:sender_address] if args[:sender_address]
      end

      def sender_address=(args)
        @sender_address = if args.is_a? ::Blackbird::Retoure::SimpleAddress
                            args
                          else
                            ::Blackbird::Retoure::SimpleAddress.new(args)
                          end
      end

      # Public: Create a JSON payload of this class.
      #
      # Returns a String representing the JSON payload.
      def to_json
        {
          receiverId: @receiver_id, customerReference: @customer_reference, shipmentReference: @shipment_reference,
          email: @email, telephoneNumber: @telephone_number, weightInGrams: @weight_in_grams, value: @value,
          senderAddress: JSON.parse(@sender_address.to_json), returnDocumentType: @return_document_type
        }.reject { |_k, v| v.blank? }.to_json
      end

      private

      # Internal: Check if the sender_address object is valid if it is
      # attached and add a error message with all the other error messages to
      # the object.
      #
      # Returns nothing.
      def validate_sender_address
        return unless sender_address.present?
        return if sender_address.valid?

        errors.add(:sender_address, "Is invalid: #{sender_address.errors.full_messages}")
      end
    end
  end
end
