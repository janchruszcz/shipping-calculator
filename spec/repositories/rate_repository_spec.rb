# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ShippingCalculator::Repositories::RateRepository do
  let(:rate1) { double('Rate', sailing_code: 'ABC123') }
  let(:rate2) { double('Rate', sailing_code: 'DEF456') }
  let(:rates) { [rate1, rate2] }
  subject(:repository) { described_class.new(rates) }

  describe '#find_by_sailing_code' do
    it 'returns the rate with the matching sailing code' do
      expect(repository.find_by_sailing_code('ABC123')).to eq(rate1)
    end

    it 'returns nil when no rate matches the sailing code' do
      expect(repository.find_by_sailing_code('XYZ789')).to be_nil
    end
  end

  describe '#all' do
    it 'returns all rates' do
      expect(repository.all).to eq(rates)
    end
  end
end
