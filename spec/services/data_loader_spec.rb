require 'spec_helper'
require_relative '../../lib/shipping_calculator/services/data_loader'

RSpec.describe ShippingCalculator::Services::DataLoader do
  describe '.load' do
    let(:json_data) do
      {
        sailings: [
          { origin_port: 'CNSHA', destination_port: 'NLRTM', departure_date: '2022-01-01', arrival_date: '2022-01-15',
            sailing_code: 'ABCD' }
        ],
        rates: [
          { sailing_code: 'ABCD', rate: '1000.50', rate_currency: 'USD' }
        ],
        exchange_rates: {
          '2022-01-01' => { 'usd' => '1.1', 'jpy' => '130.0' }
        }
      }.to_json
    end

    before do
      allow(File).to receive(:read).and_return(json_data)
    end

    it 'loads sailings correctly' do
      result = described_class.load('dummy_path')
      expect(result[:sailings].first).to be_a(ShippingCalculator::Models::Sailing)
      expect(result[:sailings].first.sailing_code).to eq('ABCD')
    end

    it 'loads rates correctly' do
      result = described_class.load('dummy_path')
      expect(result[:rates].first).to be_a(ShippingCalculator::Models::Rate)
      expect(result[:rates].first.sailing_code).to eq('ABCD')
      expect(result[:rates].first.rate).to eq(BigDecimal('1000.50'))
    end

    it 'loads exchange rates correctly' do
      result = described_class.load('dummy_path')
      expect(result[:exchange_rates].first).to be_a(ShippingCalculator::Models::ExchangeRate)
      expect(result[:exchange_rates].first.date).to eq(Date.parse('2022-01-01'))
      expect(result[:exchange_rates].first.rate_for('usd')).to eq(BigDecimal('1.1'))
    end
  end
end
