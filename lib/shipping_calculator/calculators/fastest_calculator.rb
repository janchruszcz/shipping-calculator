# frozen_string_literal: true

require_relative 'base_calculator'

module ShippingCalculator
  module Calculators
    class FastestCalculator < BaseCalculator
      def calculate(origin, destination)
        routes = find_all_routes(origin, destination)
        return nil if routes.empty?

        fastest_route = routes.min_by { |route| calculate_total_duration(route) }
        fastest_route.map { |sailing| format_result(sailing) }
      end

      private

      def calculate_total_duration(route)
        total_days = 0

        route.each_with_index do |sailing, index|
          departure_date = sailing.departure_date
          arrival_date = sailing.arrival_date

          if index > 0
            previous_arrival = route[index - 1].arrival_date
            total_days += (departure_date - previous_arrival).to_i
          end

          total_days += (arrival_date - departure_date).to_i
        end

        total_days
      end
    end
  end
end
