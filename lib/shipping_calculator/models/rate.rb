# frozen_string_literal: true

require 'bigdecimal'

module ShippingCalculator
  module Models
    class Rate
      attr_reader :sailing_code, :rate, :rate_currency

      def initialize(attributes)
        @sailing_code = attributes[:sailing_code]
        @rate_string = attributes[:rate]
        @rate = BigDecimal(@rate_string)
        @rate_currency = attributes[:rate_currency]
      end

      def to_eur(exchange_rate)
        return @rate if @rate_currency == 'EUR'

        rate_in_eur = @rate / BigDecimal(exchange_rate.rate_for(@rate_currency).to_s)
        rate_in_eur.round(2)
      end

      def rate_as_string
        @rate_string
      end
    end
  end
end
