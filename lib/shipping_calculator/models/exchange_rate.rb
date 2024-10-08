# frozen_string_literal: true

require 'date'
require 'bigdecimal'

module ShippingCalculator
  module Models
    class ExchangeRate
      attr_reader :date, :rates

      def initialize(attributes)
        @date = Date.parse(attributes[:date].to_s)
        @rates_string = attributes[:rates]
        @rates = attributes[:rates].transform_values { |v| BigDecimal(v.to_s) }
      end

      def rate_for(currency)
        currency = currency.downcase.to_sym
        return BigDecimal('1') if currency == :eur

        @rates.fetch(currency) do
          raise KeyError, "Exchange rate not found for currency: #{currency}"
        end
      end

      def to_h
        {
          date: @date.to_s,
          rates: @rates_string
        }
      end
    end
  end
end
