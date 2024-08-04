# frozen_string_literal: true

module ShippingCalculator
  module Models
    class Rate
      attr_reader :sailing_code, :rate, :rate_currency

      def initialize(attributes)
        @sailing_code = attributes[:sailing_code]
        @rate = attributes[:rate]
        @rate_currency = attributes[:rate_currency]
      end
    end
  end
end
