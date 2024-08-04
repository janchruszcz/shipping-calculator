# frozen_string_literal: true

require_relative 'shipping_calculator/services/data_loader'
require_relative 'shipping_calculator/services/shipping_calculator_service'

module ShippingCalculator
  class Application
    def initialize(data_file_path)
      @data_file_path = data_file_path
    end

    def run(origin, destination, criteria)
      data = Services::DataLoader.load(@data_file_path)
      service = Services::ShippingCalculatorService.new(data)
      service.calculate(origin, destination, criteria)
    end
  end
end
