# frozen_string_literal: true

require_relative 'shipping_calculator/services/data_loader'
require_relative 'shipping_calculator/services/shipping_calculator_service'

module ShippingCalculator
  class Application
    def initialize(data_file_path,
                   data_loader: Services::DataLoader,
                   calculator_service: Services::ShippingCalculatorService)
      @data_file_path = data_file_path
      @data_loader = data_loader
      @calculator_service = calculator_service
    end

    def run(origin, destination, criteria)
      data = @data_loader.load(@data_file_path)
      service = @calculator_service.new(data)
      service.calculate(origin, destination, criteria)
    end
  end
end
