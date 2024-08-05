# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ShippingCalculator::Calculators::BaseCalculator do
  let(:sailing_repository) { instance_double(ShippingCalculator::Repositories::SailingRepository) }
  let(:rate_repository) { instance_double(ShippingCalculator::Repositories::RateRepository) }
  let(:exchange_rate_repository) { instance_double(ShippingCalculator::Repositories::ExchangeRateRepository) }

  subject(:calculator) { described_class.new(sailing_repository, rate_repository, exchange_rate_repository) }

  describe '#calculate' do
    it 'raises NotImplementedError' do
      expect { calculator.calculate('ORIGIN', 'DESTINATION') }.to raise_error(NotImplementedError)
    end
  end

  describe '#find_direct_sailings' do
    it 'delegates to sailing_repository' do
      expect(sailing_repository).to receive(:find_direct_routes).with('ORIGIN', 'DESTINATION')
      calculator.send(:find_direct_sailings, 'ORIGIN', 'DESTINATION')
    end
  end

  describe '#find_all_routes' do
    it 'delegates to sailing_repository' do
      expect(sailing_repository).to receive(:find_all_routes).with('ORIGIN', 'DESTINATION')
      calculator.send(:find_all_routes, 'ORIGIN', 'DESTINATION')
    end
  end

  describe '#calculate_cost_in_eur' do
    let(:sailing) do
      instance_double(ShippingCalculator::Models::Sailing, sailing_code: 'ABCDE', departure_date: '2023-01-01')
    end
    let(:rate) { instance_double(ShippingCalculator::Models::Rate) }
    let(:exchange_rate) { instance_double(ShippingCalculator::Models::ExchangeRate) }

    it 'calculates cost in EUR' do
      expect(rate_repository).to receive(:find_by_sailing_code).with('ABCDE').and_return(rate)
      expect(exchange_rate_repository).to receive(:find_by_date).with('2023-01-01').and_return(exchange_rate)
      expect(rate).to receive(:to_eur).with(exchange_rate)
      calculator.send(:calculate_cost_in_eur, sailing)
    end
  end

  describe '#calculate_duration' do
    let(:sailing) do
      instance_double(ShippingCalculator::Models::Sailing, departure_date: '2023-01-01', arrival_date: '2023-01-05')
    end

    it 'calculates duration in days' do
      expect(calculator.send(:calculate_duration, sailing)).to eq(4)
    end
  end

  describe '#format_result' do
    let(:sailing) do
      instance_double(ShippingCalculator::Models::Sailing,
                      origin_port: 'ORIGIN',
                      destination_port: 'DESTINATION',
                      departure_date: '2023-01-01',
                      arrival_date: '2023-01-05',
                      sailing_code: 'ABCDE')
    end
    let(:rate) { instance_double(ShippingCalculator::Models::Rate, rate_as_string: '100.00', rate_currency: 'EUR') }

    it 'formats the result correctly' do
      expect(rate_repository).to receive(:find_by_sailing_code).with('ABCDE').and_return(rate)
      result = calculator.send(:format_result, sailing)
      expect(result).to eq({
                             origin_port: 'ORIGIN',
                             destination_port: 'DESTINATION',
                             departure_date: '2023-01-01',
                             arrival_date: '2023-01-05',
                             sailing_code: 'ABCDE',
                             rate: '100.00',
                             rate_currency: 'EUR'
                           })
    end
  end
end
