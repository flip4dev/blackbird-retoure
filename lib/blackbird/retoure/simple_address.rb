module Blackbird
  module Retoure
    # Public: Representation of DHLs SimpleClass object.
    class SimpleAddress
      include ::ActiveModel::Validations

      attr_accessor :name1, :name2, :name3, :street_name, :house_number, :post_code, :city
      attr_reader :country

      validates :name1, :street_name, :city, presence: true, length: { in: 1..35 }
      validates :name2, :name3, length: { in: 0..35 }, allow_nil: true
      # Fun fact: The server can handle longer strings...
      validates :house_number, presence: true, length: { in: 1..5 }
      # Fun fact: Even this field is tagged as a string in the documentation
      # the server will respond with a HTTP 500 if a non numerical character
      # is included.
      validates :post_code, presence: true, length: { in: 1..10 }

      # The DHL server expects a country object - even the documentation does not know this.
      validates :country, presence: true
      validate :country, :validate_country

      def initialize(args = {})
        @name1 = args[:name1]
        @name2 = args[:name2]
        @name3 = args[:name3]
        @street_name = args[:street_name]
        @house_number = args[:house_number]
        @post_code = args[:post_code]
        @city = args[:city]

        self.country = args[:country] if args[:country]
      end

      # Internal: Instantiate a new ::Blackbird::Retoure::Country class with
      # the given arguments.
      #
      # Returns nothing.
      def country=(args)
        @country = if args.is_a? ::Blackbird::Retoure::Country
                     args
                   else
                     ::Blackbird::Retoure::Country.new(args)
                   end
      end

      # Public: Create a JSON payload of this class.
      #
      # Returns a String representing the JSON payload.
      def to_json
        json_payload = {
          name1: @name1, streetName: @street_name, houseNumber: @house_number, postCode: @post_code, city: @city
        }

        json_payload[:name2] = @name2 if @name2.present?
        json_payload[:name3] = @name3 if @name3.present?
        json_payload[:country] = JSON.parse(@country.to_json) if @country.present?

        json_payload.to_json
      end

      private

      # Internal: Check if the country object is valid if it is attached and
      # add a error message with all the other error messages to the object.
      #
      # Returns nothing.
      def validate_country
        return unless country.present?
        return if country.valid?

        errors.add(:country, "Is invalid: #{country.errors.full_messages}")
      end
    end
  end
end