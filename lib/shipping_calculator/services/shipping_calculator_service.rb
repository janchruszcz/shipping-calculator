# frozen_string_literal: true

require_relative '../factories/calculator_factory'

module ShippingCalculator
  module Services
    class ShippingCalculatorService
      def initialize(repositories, calculator_factory: Factories::CalculatorFactory)
        @repositories = repositories
        @calculator_factory = calculator_factory
      end

      def calculate(origin, destination, criteria)
        calculator = @calculator_factory.create(criteria,
                                                @repositories[:sailing_repository],
                                                @repositories[:rate_repository],
                                                @repositories[:exchange_rate_repository])
        calculator.calculate(origin, destination)
      end
    end
  end
end
