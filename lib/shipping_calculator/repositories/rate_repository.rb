# frozen_string_literal: true

module ShippingCalculator
  module Repositories
    class RateRepository
      def initialize(rates)
        @rates = rates
      end

      def find_by_sailing_code(sailing_code)
        @rates.find { |r| r.sailing_code == sailing_code }
      end

      def all
        @rates
      end
    end
  end
end
