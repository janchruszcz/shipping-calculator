# frozen_string_literal: true

require_relative '../calculators/cheapest_calculator'
require_relative '../calculators/cheapest_direct_calculator'
require_relative '../calculators/fastest_calculator'

module ShippingCalculator
  module Factories
    class CalculatorFactory
      def self.create(type, sailing_repository, rate_repository, exchange_rate_repository)
        case type
        when 'cheapest'
          ShippingCalculator::Calculators::CheapestCalculator.new(sailing_repository,
                                                                  rate_repository,
                                                                  exchange_rate_repository)
        when 'cheapest-direct'
          ShippingCalculator::Calculators::CheapestDirectCalculator.new(sailing_repository,
                                                                        rate_repository,
                                                                        exchange_rate_repository)
        when 'fastest'
          ShippingCalculator::Calculators::FastestCalculator.new(sailing_repository,
                                                                 rate_repository,
                                                                 exchange_rate_repository)
        else
          raise "Unknown calculator type: #{type}"
        end
      end
    end
  end
end
