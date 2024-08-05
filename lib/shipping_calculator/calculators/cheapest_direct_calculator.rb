# frozen_string_literal: true

require_relative 'base_calculator'

module ShippingCalculator
  module Calculators
    class CheapestDirectCalculator < BaseCalculator
      def calculate(origin, destination)
        direct_sailings = find_direct_sailings(origin, destination)
        return nil if direct_sailings.empty?

        cheapest_sailing = direct_sailings.min_by { |s| calculate_cost_in_eur(s) }
        format_result(cheapest_sailing)
      end
    end
  end
end
