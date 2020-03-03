module Blackbird
  module Retoure
    # Public: Configure Blackbird::Retoure within a given block.
    #
    # username - Depending on the environment this is either your DHL username
    #   found in your dev account or the AppId of your application.
    # password - The password of your system user or your developer account.
    #   This depends on the environment you are using
    # environment - The environment you want to use. Can be :production or
    # :sandbox
    #
    # Examples
    #
    #   Blackbird::Retoure.configure do |config|
    #     config.username = '<DHL Username>'
    #     config.password = '<DHL User Password>'
    #     config.environment = :sandbox
    #   end
    #
    # Returns nothing.
    class Configuration
      attr_accessor :username, :password, :environment
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
    end
  end
end