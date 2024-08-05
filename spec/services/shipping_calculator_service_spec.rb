# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/shipping_calculator/services/shipping_calculator_service'

RSpec.describe ShippingCalculator::Services::ShippingCalculatorService do
  let(:sailing_repository) { instance_double(ShippingCalculator::Repositories::SailingRepository) }
  let(:rate_repository) { instance_double(ShippingCalculator::Repositories::RateRepository) }
  let(:exchange_rate_repository) { instance_double(ShippingCalculator::Repositories::ExchangeRateRepository) }
  let(:repositories) do
    {
      sailing_repository:,
      rate_repository:,
      exchange_rate_repository:
    }
  end

  subject(:service) { described_class.new(repositories) }

  describe '#calculate' do
    let(:origin) { 'CNSHA' }
    let(:destination) { 'NLRTM' }
    let(:criteria) { 'cheapest' }
    let(:calculator) { instance_double(ShippingCalculator::Calculators::CheapestCalculator) }

    before do
      allow(ShippingCalculator::Factories::CalculatorFactory).to receive(:create).and_return(calculator)
      allow(calculator).to receive(:calculate)
    end

    it 'calls factory to create correct calculator based on criteria' do
      service.calculate(origin, destination, criteria)
      expect(ShippingCalculator::Factories::CalculatorFactory).to have_received(:create).with(
        criteria, sailing_repository, rate_repository, exchange_rate_repository
      )
    end

    it 'calls calculate on the created calculator with correct parameters' do
      service.calculate(origin, destination, criteria)
      expect(calculator).to have_received(:calculate).with(origin, destination)
    end

    context 'with different criteria' do
      let(:criteria) { 'fastest' }

      it 'calls factory to create correct calculator based on criteria' do
        service.calculate(origin, destination, criteria)
        expect(ShippingCalculator::Factories::CalculatorFactory).to have_received(:create).with(
          'fastest', sailing_repository, rate_repository, exchange_rate_repository
        )
      end
    end
  end
end
