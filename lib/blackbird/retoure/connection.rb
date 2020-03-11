require 'net/https'
require 'base64'

module Blackbird
  module Retoure
    # Public: Connect to the DHL API an request the shipping label.
    class Connection
      attr_reader :username, :password, :environment

      ENDPOINTS = {
        production: 'https://cig.dhl.de/services/sandbox/rest/returns/',
        sandbox: 'https://cig.dhl.de/services/sandbox/rest/returns/'
      }.freeze

      SANDBOX_DPDHL_TOKEN = 'MjIyMjIyMjIyMl9jdXN0b21lcjp1QlFiWjYyIVppQmlWVmJoYw=='.freeze

      # Public: Initialize the Blackbird::Retoure::Connection object with the
      # needed configuration.
      #
      # Returns nothing.
      def initialize
        @username = ::Blackbird::Retoure.configuration.username
        @password = ::Blackbird::Retoure.configuration.password
        @app_id = ::Blackbird::Retoure.configuration.app_id
        @app_token = ::Blackbird::Retoure.configuration.app_token
        @environment = ::Blackbird::Retoure.configuration.environment
      end

      # Public: Request the DHL API with the given payload.
      #
      # Returns a Net::HTTPCreated if the label has ben successfully created
      def connect(payload)
        uri = URI.parse(ENDPOINTS[@environment])
        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          request = Net::HTTP::Post.new uri,
                                        'content-type' => 'application/json',
                                        'accept' => 'application/json'
          request.basic_auth @username, @password

          request['DPDHL-User-Authentication-Token'] = dpdhl_token

          http.request request, payload
        end
      end

      private

      # Internal: Generate the DPDHL User Authentication Token depending on
      # the environment. If it is the sandbox then a fixed authentication
      # token will be returned
      #
      # Returns a String.
      def dpdhl_token
        if @environment != :sandbox
          Base64.strict_encode64("#{@app_id}:#{@app_token}")
        else
          SANDBOX_DPDHL_TOKEN
        end
      end
    end
  end
end