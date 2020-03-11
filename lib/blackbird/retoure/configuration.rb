module Blackbird
  module Retoure
    # Public: Configure Blackbird::Retoure within a given block.
    #
    # username - Depending on the environment this is either your DHL username
    #   found in your dev account or the AppId of your application.
    # password - The password of your system user or your developer account.
    #   This depends on the environment you are using
    # environment - The environment you want to use. Can be :production or
    #   :sandbox
    # app_token - The token of the application for the CIG authentication
    #   (only needed in an production environment)
    # app_id - The application id for the CIG authentication
    #
    # Examples
    #
    #   # Sandbox environment
    #   Blackbird::Retoure.configure do |config|
    #     config.username = '<DHL Username>'
    #     config.password = '<DHL User Password>'
    #     config.environment = :sandbox
    #   end
    #
    #   # Production environment
    #   Blackbird::Retoure.configure do |config|
    #     config.username = '<DHL Username>'
    #     config.password = '<DHL User Password>'
    #     config.app_token = 'Application token for the CIG authentication'
    #     config.app_id = 'Application ID for the CIG authentication'
    #     config.environment = :sandbox
    #   end
    #
    # Returns nothing.
    class Configuration
      attr_accessor :username, :password, :environment, :app_token, :app_id
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
    end
  end
end