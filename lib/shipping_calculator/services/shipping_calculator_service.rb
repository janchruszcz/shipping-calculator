# frozen_string_literal: true

require_relative '../factories/calculator_factory'

module ShippingCalculator
  module Services
    # Calculates shipping costs based on origin, destination, and criteria (cheapest, fastest, cheapest-direct)
    class ShippingCalculatorService
      def initialize(repositories)
        @repositories = repositories
      end

      def calculate(origin, destination, criteria)
        calculator = Factories::CalculatorFactory.create(criteria,
                                                         @repositories[:sailing_repository],
                                                         @repositories[:rate_repository],
                                                         @repositories[:exchange_rate_repository])
        calculator.calculate(origin, destination)
      end
    end
  end
end
