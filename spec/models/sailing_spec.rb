# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ShippingCalculator::Models::Sailing do
  let(:sailing) { build(:sailing) }

  describe '#initialize' do
    it 'creates a valid sailing' do
      expect(sailing).to be_a(described_class)
    end

    it 'sets attributes correctly' do
      expect(sailing.origin_port).to eq('CNSHA')
      expect(sailing.destination_port).to eq('NLRTM')
      expect(sailing.departure_date).to eq(Date.new(2024, 1, 1))
      expect(sailing.arrival_date).to eq(Date.new(2024, 1, 2))
      expect(sailing.sailing_code).to eq('ABCDE')
    end
  end
end
