module Blackbird
  module Retoure
    # Public: Configure Blackbird::Retoure within a given block.
    #
    # Examples
    #
    #   Blackbird::Retoure.configure do |config|
    #     config.username = '<DHL Username>'
    #     config.password = '<DHL User Password>'
    #   end
    #
    # Returns nothing.
    class Configuration
      attr_accessor :username, :password
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
    end
  end
end