# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ShippingCalculator::Calculators::CheapestCalculator do
  let(:sailing_repository) { instance_double(ShippingCalculator::Repositories::SailingRepository) }
  let(:rate_repository) { instance_double(ShippingCalculator::Repositories::RateRepository) }
  let(:exchange_rate_repository) { instance_double(ShippingCalculator::Repositories::ExchangeRateRepository) }

  subject(:calculator) { described_class.new(sailing_repository, rate_repository, exchange_rate_repository) }

  describe '#calculate' do
    let(:origin) { 'CNSHA' }
    let(:destination) { 'NLRTM' }
    let(:direct_sailing) { build(:sailing, origin_port: origin, destination_port: destination, sailing_code: 'DIRECT') }
    let(:indirect_sailing1) do
      build(:sailing, origin_port: origin, destination_port: 'SGSIN', sailing_code: 'INDIRECT1')
    end
    let(:indirect_sailing2) do
      build(:sailing, origin_port: 'SGSIN', destination_port: destination, sailing_code: 'INDIRECT2')
    end

    let(:direct_rate) { build(:rate, sailing_code: 'DIRECT', rate: 1000, rate_currency: 'USD') }
    let(:indirect_rate1) { build(:rate, sailing_code: 'INDIRECT1', rate: 500, rate_currency: 'USD') }
    let(:indirect_rate2) { build(:rate, sailing_code: 'INDIRECT2', rate: 600, rate_currency: 'USD') }

    let(:exchange_rate) { build(:exchange_rate, rates: { 'USD' => '0.85' }) }

    before do
      allow(sailing_repository).to receive(:find_all_routes).with(origin, destination)
                                                            .and_return([[direct_sailing],
                                                                         [indirect_sailing1, indirect_sailing2]])

      allow(rate_repository).to receive(:find_by_sailing_code).with('DIRECT').and_return(direct_rate)
      allow(rate_repository).to receive(:find_by_sailing_code).with('INDIRECT1').and_return(indirect_rate1)
      allow(rate_repository).to receive(:find_by_sailing_code).with('INDIRECT2').and_return(indirect_rate2)

      allow(exchange_rate_repository).to receive(:find_by_date).and_return(exchange_rate)
      allow(direct_rate).to receive(:to_eur).with(exchange_rate).and_return(BigDecimal('1000'))
      allow(indirect_rate1).to receive(:to_eur).with(exchange_rate).and_return(BigDecimal('500'))
      allow(indirect_rate2).to receive(:to_eur).with(exchange_rate).and_return(BigDecimal('600'))
    end

    it 'returns the cheapest route' do
      result = calculator.calculate(origin, destination)
      expect(result).to be_an(Array)
      expect(result.size).to eq(1)
      expect(result.first[:sailing_code]).to eq('DIRECT')
    end

    context 'when indirect route is cheaper' do
      let(:direct_rate) { build(:rate, sailing_code: 'DIRECT', rate: 2000, rate_currency: 'USD') }

      before do
        allow(direct_rate).to receive(:to_eur).with(exchange_rate).and_return(BigDecimal('2000'))
      end

      it 'returns the indirect route' do
        result = calculator.calculate(origin, destination)
        expect(result).to be_an(Array)
        expect(result.size).to eq(2)
        expect(result.map { |r| r[:sailing_code] }).to eq(%w[INDIRECT1 INDIRECT2])
      end
    end

    context 'when no routes are found' do
      before do
        allow(sailing_repository).to receive(:find_all_routes).with(origin, destination)
                                                              .and_return([])
      end

      it 'returns nil' do
        expect(calculator.calculate(origin, destination)).to be_nil
      end
    end
  end
end
