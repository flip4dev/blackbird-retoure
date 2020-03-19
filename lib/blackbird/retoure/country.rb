require 'active_model'

module Blackbird
  module Retoure
    # Public: This class represents the Country section of the DHL payload.
    # It validates the fields and provides a #to_json function.
    #
    # country_iso_code - String alpha-3 ISO country code.
    # country - String country designation (optional).
    # state - String state (optional).
    class Country
      include ::ActiveModel::Validations

      attr_accessor :country_iso_code, :country, :state

      validates :country_iso_code, presence: true, length: { is: 3 }
      validates :country, :state, length: { in: 0..30 }, allow_nil: true

      def initialize(args = {})
        @country_iso_code = args[:country_iso_code]
        @country = args[:country]
        @state = args[:state]
      end

      # Public: Create a JSON payload of this class.
      #
      # Returns a String representing the JSON payload.
      def to_json
        json = { countryISOCode: @country_iso_code }
        json.store(:country, @country) unless @country.blank?
        json.store(:state, @state) unless @state.blank?

        json.to_json
      end
    end
  end
end
