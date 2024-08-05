# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/shipping_calculator/calculators/cheapest_direct_calculator'

RSpec.describe ShippingCalculator::Calculators::CheapestDirectCalculator do
  let(:sailing_repository) { instance_double(ShippingCalculator::Repositories::SailingRepository) }
  let(:rate_repository) { instance_double(ShippingCalculator::Repositories::RateRepository) }
  let(:exchange_rate_repository) { instance_double(ShippingCalculator::Repositories::ExchangeRateRepository) }

  subject(:calculator) { described_class.new(sailing_repository, rate_repository, exchange_rate_repository) }

  describe '#calculate' do
    let(:origin) { 'CNSHA' }
    let(:destination) { 'NLRTM' }
    let(:sailing1) do
      instance_double(ShippingCalculator::Models::Sailing, origin_port: 'CNSHA', destination_port: 'NLRTM',
                                                           sailing_code: 'ABCD', departure_date: Date.new(2023, 1, 1),
                                                           arrival_date: Date.new(2023, 1, 2))
    end
    let(:sailing2) do
      instance_double(ShippingCalculator::Models::Sailing, origin_port: 'CNSHA', destination_port: 'NLRTM',
                                                           sailing_code: 'EFGH', departure_date: Date.new(2023, 1, 2),
                                                           arrival_date: Date.new(2023, 1, 3))
    end
    let(:rate1) do
      instance_double(ShippingCalculator::Models::Rate, rate: BigDecimal('1000'), rate_as_string: '1000.00',
                                                        rate_currency: 'USD')
    end
    let(:rate2) do
      instance_double(ShippingCalculator::Models::Rate, rate: BigDecimal('900'), rate_as_string: '900.00',
                                                        rate_currency: 'EUR')
    end
    let(:exchange_rate) { instance_double(ShippingCalculator::Models::ExchangeRate) }

    before do
      allow(sailing_repository).to receive(:find_direct_routes).with(origin,
                                                                     destination).and_return([sailing1, sailing2])
      allow(rate_repository).to receive(:find_by_sailing_code).with('ABCD').and_return(rate1)
      allow(rate_repository).to receive(:find_by_sailing_code).with('EFGH').and_return(rate2)
      allow(exchange_rate_repository).to receive(:find_by_date).and_return(exchange_rate)
      allow(rate1).to receive(:to_eur).with(exchange_rate).and_return(BigDecimal('1000'))
      allow(rate2).to receive(:to_eur).with(exchange_rate).and_return(BigDecimal('900'))
    end

    it 'returns the cheapest direct route' do
      result = calculator.calculate(origin, destination)
      expect(result).to include(
        origin_port: origin,
        destination_port: destination,
        sailing_code: 'EFGH',
        rate: '900.00',
        rate_currency: 'EUR'
      )
    end

    context 'when no direct routes are available' do
      before do
        allow(sailing_repository).to receive(:find_direct_routes).with(origin, destination).and_return([])
      end

      it 'returns nil' do
        expect(calculator.calculate(origin, destination)).to be_nil
      end
    end
  end
end
