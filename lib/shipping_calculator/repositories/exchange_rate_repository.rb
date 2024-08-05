# frozen_string_literal: true

module ShippingCalculator
  module Repositories
    class ExchangeRateRepository
      def initialize(exchange_rates)
        @exchange_rates = exchange_rates
      end

      def find_by_date(date)
        @exchange_rates.find { |er| er.date == date }
      end

      def all
        @exchange_rates
      end
    end
  end
end
