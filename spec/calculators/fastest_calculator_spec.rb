# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ShippingCalculator::Calculators::FastestCalculator do
  let(:sailing_repository) { instance_double(ShippingCalculator::Repositories::SailingRepository) }
  let(:rate_repository) { instance_double(ShippingCalculator::Repositories::RateRepository) }
  let(:exchange_rate_repository) { instance_double(ShippingCalculator::Repositories::ExchangeRateRepository) }

  subject(:calculator) { described_class.new(sailing_repository, rate_repository, exchange_rate_repository) }

  describe '#calculate' do
    let(:origin) { 'CNSHA' }
    let(:destination) { 'NLRTM' }
    let(:direct_sailing) do
      build(:sailing, origin_port: origin, destination_port: destination,
                      departure_date: '2023-01-01', arrival_date: '2023-01-15', sailing_code: 'DIRECT')
    end
    let(:indirect_sailing1) do
      build(:sailing, origin_port: origin, destination_port: 'SGSIN',
                      departure_date: '2023-01-01', arrival_date: '2023-01-05', sailing_code: 'INDIRECT1')
    end
    let(:indirect_sailing2) do
      build(:sailing, origin_port: 'SGSIN', destination_port: destination,
                      departure_date: '2023-01-07', arrival_date: '2023-01-14', sailing_code: 'INDIRECT2')
    end
    let(:direct_rate) { build(:rate, sailing_code: 'DIRECT', rate: 100) }
    let(:indirect_rate1) { build(:rate, sailing_code: 'INDIRECT1', rate: 200) }
    let(:indirect_rate2) { build(:rate, sailing_code: 'INDIRECT2', rate: 300) }

    before do
      allow(sailing_repository).to receive(:find_all_routes).with(origin, destination)
                                                            .and_return([[direct_sailing],
                                                                         [indirect_sailing1, indirect_sailing2]])
      allow(rate_repository).to receive(:find_by_sailing_code).with(direct_sailing.sailing_code).and_return(direct_rate)
      allow(rate_repository).to receive(:find_by_sailing_code).with(indirect_sailing1.sailing_code).and_return(indirect_rate1)
      allow(rate_repository).to receive(:find_by_sailing_code).with(indirect_sailing2.sailing_code).and_return(indirect_rate2)
    end

    it 'returns the fastest route' do
      result = calculator.calculate(origin, destination)
      expect(result).to be_an(Array)
      expect(result.size).to eq(2)
      expect(result.map { |r| r[:sailing_code] }).to eq(%w[INDIRECT1 INDIRECT2])
    end

    context 'when direct route is faster' do
      let(:direct_sailing) do
        build(:sailing, origin_port: origin, destination_port: destination,
                        departure_date: '2023-01-01', arrival_date: '2023-01-10', sailing_code: 'DIRECT')
      end

      it 'returns the direct route' do
        result = calculator.calculate(origin, destination)
        expect(result).to be_an(Array)
        expect(result.size).to eq(1)
        expect(result.first[:sailing_code]).to eq('DIRECT')
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
