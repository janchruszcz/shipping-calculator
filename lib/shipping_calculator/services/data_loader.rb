# frozen_string_literal: true

require 'json'
require_relative '../models/sailing'
require_relative '../models/rate'
require_relative '../models/exchange_rate'
require_relative '../repositories/sailing_repository'
require_relative '../repositories/rate_repository'
require_relative '../repositories/exchange_rate_repository'

module ShippingCalculator
  module Services
    class DataLoader
      def self.load(file_path)
        data = JSON.parse(File.read(file_path), symbolize_names: true)

        {
          sailing_repository: load_sailings(data[:sailings]),
          rate_repository: load_rates(data[:rates]),
          exchange_rate_repository: load_exchange_rates(data[:exchange_rates])
        }
      end

      def self.load_sailings(data)
        sailings = data.map { |item| ShippingCalculator::Models::Sailing.new(item) }
        ShippingCalculator::Repositories::SailingRepository.new(sailings)
      end

      def self.load_rates(data)
        rates = data.map { |item| ShippingCalculator::Models::Rate.new(item) }
        ShippingCalculator::Repositories::RateRepository.new(rates)
      end

      def self.load_exchange_rates(data)
        exchange_rates = data.map do |date, rates|
          ShippingCalculator::Models::ExchangeRate.new({ date:, rates: })
        end
        ShippingCalculator::Repositories::ExchangeRateRepository.new(exchange_rates)
      end
    end
  end
end
