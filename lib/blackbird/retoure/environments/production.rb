require 'base64'

module Blackbird
  module Retoure
    module Environments
      # Public: Sandbox environment specific functions
      class Production < ::Blackbird::Retoure::Environments::Base
        ENDPOINT = 'https://cig.dhl.de/services/production/rest/returns/'.freeze

        # Internal: Return the authentication data needed for the HTTP
        # Basic authentication.
        #
        # Returns an Array containing the username and the password to use for
        #   the CIG HTTP Basic authentication.
        def authentication_data
          [@app_id, @app_token]
        end

        # Internal: Generate the DPDHL User Authentication Token
        #
        # Returns a String.
        def dpdhl_token
          Base64.strict_encode64("#{@username}:#{@password}")
        end
      end
    end
  end
end