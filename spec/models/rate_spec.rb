# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ShippingCalculator::Models::Rate do
  let(:rate) { build(:rate) }

  describe '#initialize' do
    it 'creates a valid rate' do
      expect(rate).to be_a(described_class)
    end

    it 'sets attributes correctly' do
      expect(rate.sailing_code).to eq('ABCDE')
      expect(rate.rate).to eq(BigDecimal('100'))
      expect(rate.rate_currency).to eq('EUR')
    end
  end
end
