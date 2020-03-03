require 'blackbird/retoure/version'
require 'blackbird/retoure/configuration'
require 'blackbird/retoure/country'
require 'blackbird/retoure/simple_address'
require 'blackbird/retoure/return_order'
require 'blackbird/retoure/response'
require 'blackbird/retoure/connection'

module Blackbird
  module Retoure
    def self.retoure_label(args)
      return_order = ::Blackbird::Retoure::ReturnOrder.new(args)
      raise InvalidDataError.new(messages: return_order.errors.full_messages) if return_order.invalid?
    end

    class InvalidDataError < StandardError; end
    # Your code goes here...
  end
end
