require 'blackbird/retoure/version'
require 'blackbird/retoure/configuration'
require 'blackbird/retoure/country'
require 'blackbird/retoure/simple_address'
require 'blackbird/retoure/return_order'
require 'blackbird/retoure/connection'
require 'blackbird/retoure/environments/base'
require 'blackbird/retoure/environments/sandbox'
require 'blackbird/retoure/environments/production'

module Blackbird
  # Public: Retrieve DHL Retoure labels.
  # This GEM handles the connection and a basic validation of the data.
  #
  # args - A Hash containing the needed data for the DHL Retoure api.
  # The minimum amount of fields is shown in the examples section and this
  # gem tries to validate them as much as possible (according to the official
  # documentation and undocumented "features" found).
  #
  # If no error has been raised this class will always return a Net::HTTP klass
  # which #body needs to be parsed by an JSON parser.
  #
  # Examples
  #
  #   # Minimum amount of data needed
  #   args = {
  #     receiver_id: 'DE',
  #     sender_address: {
  #       name1: 'Name #1',
  #       street_name: 'Street Name',
  #       house_number: 'House Number #',
  #       post_code: '12345',
  #       city: 'City',
  #       country: { country_iso_code: 'DEU' }
  #     }
  #   }
  #   # Retrieve a single shipping label with the least amount of data.
  #   shipping_label = Blackbird::Retoure.shipping_label(args)
  #   # => <#Net::HTTPCreated ...>
  #
  #   # Just retrieve a QR code
  #   qr_code = Blackbird::Retoure.qr_code(args)
  #   # => <#Net::HTTPCreated ...>
  #
  #   # Receive both documents (shipping label and qr code)
  #   both_documents = Blackbird::Retoure.both(args)
  #   # => <#Net::HTTPCreated ...>
  #
  #   JSON.parse(shipping_label.body)
  #   # => { "shipmentNumber" => "1234...7788", "labelData"=>"JVBERi0xLjQKJeLjz9...",
  #          "qrLabelData" => nil, "routingCode"=>"40327653113+99000933090010" }
  #
  #   JSON.parse(qr_code.body)
  #   # => { "shipmentNumber" => "7788...123", "labelData" => nil,
  #          "qrLabelData" => "qCN5mWUTmGcQ63u+X...",
  #          "routingCode" => "40327653113+99000933090010" }
  #
  #   JSON.parse(both_documents.body)
  #   # => { "shipmentNumber" => "5674...234",
  #          "labelData" => "SzXSRCOoGNSMR1Jxe...",
  #          "qrLabelData" => "HWpJoepUeCctmTSzSZ...",
  #          "routingCode" => "40327653113+99000933090010" }
  module Retoure
    class << self
      # Public: Receive only a shipping label
      #
      # args - The combined Hash data provided by the calling functions.
      #
      # Returns a Net::HTTPCreated if the label has been created.
      # Returns a Net::HTTPBadRequest if there are errors within the given data
      #   that is not being validated by this gem.
      # Returns a Net::HTTPInternalServerError if there is an error happening
      #   within the DHL Server. This can happen in certain (undocumented)
      #   situations within the payload. This gem tries to prevent such
      #   situations for known issues.
      # Raises an ::Blackbird::Retoure::InvalidDataError if there are any
      #   errors in the given data.
      def shipping_label(args)
        retrieve_label(args)
      end

      # Public: Receive a QR code. This will also create a new shipment number.
      # It is not possible to create a QR code after a shipping label has been
      # created!
      #
      # args - The combined Hash data provided by the calling functions.
      #
      # Returns a Net::HTTPCreated if the label has been created.
      # Returns a Net::HTTPBadRequest if there are errors within the given data
      #   that is not being validated by this gem.
      # Returns a Net::HTTPInternalServerError if there is an error happening
      #   within the DHL Server. This can happen in certain (undocumented)
      #   situations within the payload. This gem tries to prevent such
      #   situations for known issues.
      # Raises an ::Blackbird::Retoure::InvalidDataError if there are any
      #   errors in the given data.
      def qr_code(args)
        args[:return_document_type] = 'QR_LABEL'

        retrieve_label(args)
      end

      # Public: Receive a shipping label AND a QR code in one call.
      #
      # args - The combined Hash data provided by the calling functions.
      #
      # Returns a Net::HTTPCreated if the label has been created.
      # Returns a Net::HTTPBadRequest if there are errors within the given data
      #   that is not being validated by this gem.
      # Returns a Net::HTTPInternalServerError if there is an error happening
      #   within the DHL Server. This can happen in certain (undocumented)
      #   situations within the payload. This gem tries to prevent such
      #   situations for known issues.
      # Raises an ::Blackbird::Retoure::InvalidDataError if there are any
      #   errors in the given data.
      def both(args)
        args[:return_document_type] = 'BOTH'

        retrieve_label(args)
      end

      private

      # Internal: Retrieve the shipping label from DHL.
      #
      # args - The combined Hash data provided by the calling functions.
      #
      # Returns a Net::HTTPCreated if the label has been created.
      # Returns a Net::HTTPBadRequest if there are errors within the given data
      #   that is not being validated by this gem.
      # Returns a Net::HTTPInternalServerError if there is an error happening
      #   within the DHL Server. This can happen in certain (undocumented)
      #   situations within the payload. This gem tries to prevent such
      #   situations for known issues.
      # Raises an ::Blackbird::Retoure::InvalidDataError if there are any
      #   errors in the given data.
      def retrieve_label(args)
        return_order = ::Blackbird::Retoure::ReturnOrder.new(args)
        raise InvalidDataError.new(messages: return_order.errors.full_messages) if return_order.invalid?

        connection = ::Blackbird::Retoure::Connection.new
        connection.connect(return_order.to_json)
      end
    end

    class InvalidDataError < StandardError; end
  end
end
