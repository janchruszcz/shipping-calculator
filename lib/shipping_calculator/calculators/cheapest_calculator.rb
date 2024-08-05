# frozen_string_literal: true

require_relative 'base_calculator'

module ShippingCalculator
  module Calculators
    class CheapestCalculator < BaseCalculator
      def calculate(origin, destination)
        routes = find_all_routes(origin, destination)
        return nil if routes.empty?

        cheapest_route = routes.min_by { |route| calculate_total_cost(route) }
        format_route(cheapest_route)
      end

      private

      def calculate_total_cost(route)
        sailings = route.is_a?(Array) ? route : [route]
        sailings.sum { |sailing| calculate_cost_in_eur(sailing) }
      end

      def format_route(route)
        sailings = route.is_a?(Array) ? route : [route]
        sailings.map { |sailing| format_result(sailing) }
      end
    end
  end
end
