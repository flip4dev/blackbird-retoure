module Blackbird
  module Retoure
    module Environments
      # Public: Sandbox environment specific functions
      class Sandbox < ::Blackbird::Retoure::Environments::Base
        ENDPOINT = 'https://cig.dhl.de/services/sandbox/rest/returns/'.freeze

        # Internal: Return the authentication data needed for the HTTP
        # Basic authentication.
        #
        # Returns an Array containing the username and the password to use for
        #   the CIG HTTP Basic authentication.
        def authentication_data
          [@username, @password]
        end

        # Internal: Generate the DPDHL User Authentication Token.
        #
        # Returns a String.
        def dpdhl_token
          'MjIyMjIyMjIyMl9jdXN0b21lcjp1QlFiWjYyIVppQmlWVmJoYw=='
        end
      end
    end
  end
end