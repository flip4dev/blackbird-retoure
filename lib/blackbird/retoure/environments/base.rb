module Blackbird
  module Retoure
    module Environments
      # Internal: Provide environment specific methods.
      class Base
        def initialize
          @username = ::Blackbird::Retoure.configuration.username
          @password = ::Blackbird::Retoure.configuration.password
          @app_id = ::Blackbird::Retoure.configuration.app_id
          @app_token = ::Blackbird::Retoure.configuration.app_token
        end

        # Public: Returns the endpoint url for the current environment.
        # The ENDPOINT constant has to be implemented in the child classes.
        #
        # Returns as String.
        def endpoint_url
          self.class::ENDPOINT
        end
      end
    end
  end
end