# frozen_string_literal: true

require_relative '../factories/calculator_factory'

module ShippingCalculator
  module Services
    # Calculates shipping costs based on origin, destination, and criteria (cheapest, fastest, cheapest-direct)
    class ShippingCalculatorService
      def initialize(data)
        @data = data
      end

      def calculate(origin, destination, criteria)
        data = @data
        calculator = Factories::CalculatorFactory.create(criteria,
                                                         data[:sailings],
                                                         data[:rates],
                                                         data[:exchange_rates])
        calculator.calculate(origin, destination)
      end
    end
  end
end
