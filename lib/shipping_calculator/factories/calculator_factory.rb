# frozen_string_literal: true

require_relative '../calculators/cheapest_calculator'
require_relative '../calculators/cheapest_direct_calculator'
require_relative '../calculators/fastest_calculator'

module ShippingCalculator
  module Factories
    class CalculatorFactory
      def self.create(type, sailings, rates, exchange_rates)
        case type
        when 'cheapest'
          ShippingCalculator::Calculators::CheapestCalculator.new(sailings, rates, exchange_rates)
        when 'cheapest-direct'
          ShippingCalculator::Calculators::CheapestDirectCalculator.new(sailings, rates, exchange_rates)
        when 'fastest'
          ShippingCalculator::Calculators::FastestCalculator.new(sailings, rates, exchange_rates)
        else
          raise "Unknown calculator type: #{type}"
        end
      end
    end
  end
end
