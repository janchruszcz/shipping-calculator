require 'spec_helper'
require 'json'
require_relative '../../lib/shipping_calculator/services/data_loader'

RSpec.describe ShippingCalculator::Services::DataLoader do
  describe '.load' do
    let(:json_data) do
      JSON.dump({
                  sailings: [
                    { origin_port: 'CNSHA', destination_port: 'NLRTM', departure_date: '2022-01-01', arrival_date: '2022-01-15',
                      sailing_code: 'ABCD' }
                  ],
                  rates: [
                    { sailing_code: 'ABCD', rate: '1000.50', rate_currency: 'USD' }
                  ],
                  exchange_rates: {
                    '2022-01-01' => { usd: '1.1', jpy: '130.0' }
                  }
                })
    end

    before do
      allow(File).to receive(:read).and_return(json_data)
    end

    let(:result) { described_class.load('dummy_path') }

    it 'returns a hash with repository keys' do
      expect(result.keys).to match_array(%i[sailing_repository rate_repository exchange_rate_repository])
    end

    it 'creates a SailingRepository with correct data' do
      expect(result[:sailing_repository]).to be_a(ShippingCalculator::Repositories::SailingRepository)
      sailings = result[:sailing_repository].find_direct_routes('CNSHA', 'NLRTM')
      expect(sailings.length).to eq(1)
      expect(sailings.first.sailing_code).to eq('ABCD')
    end

    it 'creates a RateRepository with correct data' do
      expect(result[:rate_repository]).to be_a(ShippingCalculator::Repositories::RateRepository)
      rate = result[:rate_repository].find_by_sailing_code('ABCD')
      expect(rate).to be_a(ShippingCalculator::Models::Rate)
      expect(rate.rate).to eq(BigDecimal('1000.50'))
      expect(rate.rate_currency).to eq('USD')
    end

    it 'creates an ExchangeRateRepository with correct data' do
      expect(result[:exchange_rate_repository]).to be_a(ShippingCalculator::Repositories::ExchangeRateRepository)
      exchange_rate = result[:exchange_rate_repository].find_by_date(Date.parse('2022-01-01'))
      expect(exchange_rate).to be_a(ShippingCalculator::Models::ExchangeRate)
      expect(exchange_rate.rate_for(:usd)).to eq(BigDecimal('1.1'))
      expect(exchange_rate.rate_for(:jpy)).to eq(BigDecimal('130.0'))
    end
  end
end
