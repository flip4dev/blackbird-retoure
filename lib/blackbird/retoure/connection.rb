require 'net/https'

module Blackbird
  module Retoure
    # Public: Connect to the DHL API an request the shipping label.
    class Connection
      # Public: Initialize the Blackbird::Retoure::Connection object with the
      # needed environment.
      #
      # Returns nothing.
      def initialize
        @environment = "::Blackbird::Retoure::Environments::\
#{::Blackbird::Retoure.configuration.environment.to_s.camelize}".constantize.new
      end

      # Public: Request the DHL API with the given payload.
      #
      # payload - String encoded JSON object that is going to be sent to DHL.
      #
      # Examples
      #   payload = {
      #     receiver_id: 'DE',
      #     sender_address: {
      #       name1: 'Name #1',
      #       street_name: 'Street Name',
      #       house_number: 'House Number #',
      #       post_code: '12345',
      #       city: 'City',
      #       country: { country_iso_code: 'DEU' }
      #     }
      #   }.to_json
      #
      #   ::Blackbird::Retoure::Connection.new.connect(payload)
      #   # => <#Net::HTTPCreated ...>
      #
      # Returns a Net::HTTPCreated if the label has ben successfully created
      # Returns a Net::HTTPBadRequest if there are errors within the given data
      #   that is not being validated by this gem.
      # Returns a Net::HTTPInternalServerError if there is an error happening
      #   within the DHL Server. This can happen in certain (undocumented)
      #   situations within the payload. This gem tries to prevent such
      #   situations for known issues.
      # Raises an ::Blackbird::Retoure::InvalidDataError if there are any
      #   errors in the given data.
      def connect(payload)
        uri = URI.parse(@environment.endpoint_url)
        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          request = Net::HTTP::Post.new uri,
                                        'content-type' => 'application/json',
                                        'accept' => 'application/json'
          request.basic_auth(*@environment.authentication_data)

          request['DPDHL-User-Authentication-Token'] = @environment.dpdhl_token

          http.request request, payload
        end
      end
    end
  end
end
