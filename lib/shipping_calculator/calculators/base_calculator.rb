# frozen_string_literal: true

require 'date'

module ShippingCalculator
  module Calculators
    class BaseCalculator
      def initialize(sailing_repository, rate_repository, exchange_rate_repository)
        @sailing_repository = sailing_repository
        @rate_repository = rate_repository
        @exchange_rate_repository = exchange_rate_repository
      end

      def calculate(origin, destination)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      protected

      def find_direct_sailings(origin, destination)
        @sailing_repository.find_direct_routes(origin, destination)
      end

      def find_all_routes(origin, destination)
        @sailing_repository.find_all_routes(origin, destination)
      end

      def calculate_cost_in_eur(sailing)
        rate = @rate_repository.find_by_sailing_code(sailing.sailing_code)
        exchange_rate = @exchange_rate_repository.find_by_date(sailing.departure_date)
        rate.to_eur(exchange_rate)
      end

      def calculate_duration(sailing)
        (Date.parse(sailing.arrival_date) - Date.parse(sailing.departure_date)).to_i
      end

      def format_result(sailing)
        rate = @rate_repository.find_by_sailing_code(sailing.sailing_code)
        {
          origin_port: sailing.origin_port,
          destination_port: sailing.destination_port,
          departure_date: sailing.departure_date,
          arrival_date: sailing.arrival_date,
          sailing_code: sailing.sailing_code,
          rate: rate.rate_as_string,
          rate_currency: rate.rate_currency
        }
      end
    end
  end
end
