# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ShippingCalculator::Models::ExchangeRate do
  let(:exchange_rate) { build(:exchange_rate) }

  describe '#initialize' do
    it 'creates a valid exchange rate' do
      expect(exchange_rate).to be_a(described_class)
    end

    it 'sets attributes correctly' do
      expect(exchange_rate.date).to eq(Date.new(2023, 1, 1))
      expect(exchange_rate.rates).to eq({ 'USD' => BigDecimal('1.19'), 'GBP' => BigDecimal('0.75') })
    end
  end
end
