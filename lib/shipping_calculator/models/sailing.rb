# frozen_string_literal: true

module ShippingCalculator
  module Models
    class Sailing
      attr_reader :origin_port, :destination_port, :departure_date, :arrival_date, :sailing_code

      def initialize(attributes)
        @origin_port = attributes[:origin_port]
        @destination_port = attributes[:destination_port]
        @departure_date = Date.parse(attributes[:departure_date])
        @arrival_date = Date.parse(attributes[:arrival_date])
        @sailing_code = attributes[:sailing_code]
      end
    end
  end
end
