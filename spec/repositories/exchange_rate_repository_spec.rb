# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ShippingCalculator::Repositories::ExchangeRateRepository do
  let(:date1) { Date.new(2023, 1, 1) }
  let(:date2) { Date.new(2023, 1, 2) }
  let(:exchange_rate1) { build(:exchange_rate, date: date1) }
  let(:exchange_rate2) { build(:exchange_rate, date: date2) }
  let(:exchange_rates) { [exchange_rate1, exchange_rate2] }
  subject(:repository) { described_class.new(exchange_rates) }

  describe '#find_by_date' do
    it 'returns the exchange rate for the given date' do
      expect(repository.find_by_date(date1)).to eq(exchange_rate1)
    end

    it 'returns nil when no exchange rate is found for the given date' do
      expect(repository.find_by_date(Date.new(2023, 1, 3))).to be_nil
    end
  end

  describe '#all' do
    it 'returns all exchange rates' do
      expect(repository.all).to eq(exchange_rates)
    end
  end
end
