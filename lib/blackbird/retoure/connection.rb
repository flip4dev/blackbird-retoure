require 'net/https'
require 'base64'

module Blackbird
  module Retoure
    # Public: Connect to the DHL API an request the shipping label.
    class Connection
      ENDPOINTS = {
        production: 'https://cig.dhl.de/services/production/rest/returns/',
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
      # Returns a Net::HTTPBadRequest if there are errors within the given data
      #   that is not being validated by this gem.
      # Returns a Net::HTTPInternalServerError if there is an error happening
      #   within the DHL Server. This can happen in certain (undocumented)
      #   situations within the payload. This gem tries to prevent such
      #   situations for known issues.
      # Raises an ::Blackbird::Retoure::InvalidDataError if there are any
      #   errors in the given data.
      def connect(payload)
        uri = URI.parse(ENDPOINTS[@environment])
        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          request = Net::HTTP::Post.new uri,
                                        'content-type' => 'application/json',
                                        'accept' => 'application/json'
          request.basic_auth(*authentication_data(@environment))

          request['DPDHL-User-Authentication-Token'] = dpdhl_token(@environment)

          http.request request, payload
        end
      end

      private

      # Internal: Return the correct authentication data needed for the HTTP
      # Basic authentication.
      #
      # environment - The String or Symbol environment that is going to be
      # used for the CIG authentication.
      #
      # Returns an Array containing the username and the password to use for
      #   the CIG HTTP Basic authentication.
      def authentication_data(environment)
        environment.to_sym == :sandbox ? [@username, @password] : [@app_id, @app_token]
      end

      # Internal: Generate the DPDHL User Authentication Token depending on
      # the environment. If it is the sandbox then a fixed authentication
      # token will be returned
      #
      # environment - The String or Symbol environment that is going to be
      # used for the CIG authentication.
      #
      # Returns a String.
      def dpdhl_token(environment)
        if environment.to_sym != :sandbox
          Base64.strict_encode64("#{@username}:#{@password}")
        else
          SANDBOX_DPDHL_TOKEN
        end
      end
    end
  end
end
