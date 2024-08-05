require 'spec_helper'
require 'json'

RSpec.describe ShippingCalculator::Application do
  let(:data_file_path) { File.join(File.dirname(__FILE__), '..', '..', 'data', 'response.json') }
  let(:app) { described_class.new(data_file_path) }

  describe '#run' do
    subject(:result) { app.run(origin, destination, criteria) }

    let(:origin) { 'CNSHA' }
    let(:destination) { 'NLRTM' }

    context 'when calculating cheapest-direct route' do
      let(:criteria) { 'cheapest-direct' }

      it 'returns the correct cheapest direct route' do
        expect(result).to include(
          origin_port: 'CNSHA',
          destination_port: 'NLRTM',
          sailing_code: 'MNOP',
          rate: '456.78',
          rate_currency: 'USD'
        )
      end
    end

    context 'when calculating cheapest route' do
      let(:criteria) { 'cheapest' }

      it 'returns the correct cheapest route' do
        expect(result[0]).to include(
          origin_port: 'CNSHA',
          destination_port: 'ESBCN',
          sailing_code: 'ERXQ',
          rate: '261.96',
          rate_currency: 'EUR'
        )
        expect(result[1]).to include(
          origin_port: 'ESBCN',
          destination_port: 'NLRTM',
          sailing_code: 'ETRG',
          rate: '69.96',
          rate_currency: 'USD'
        )
      end
    end

    context 'when calculating fastest route' do
      let(:criteria) { 'fastest' }

      it 'returns the correct fastest route' do
        route = result.first
        expect(route).to include(
          origin_port: 'CNSHA',
          destination_port: 'NLRTM',
          sailing_code: 'QRST',
          rate: '761.96',
          rate_currency: 'EUR'
        )
      end
    end

    context 'when given invalid criteria' do
      let(:criteria) { 'invalid_criteria' }

      it 'raises an error' do
        expect { result }.to raise_error(RuntimeError, /Unknown calculator type/)
      end
    end

    context 'when given invalid ports' do
      let(:origin) { 'INVALID' }
      let(:destination) { 'PORT' }
      let(:criteria) { 'cheapest' }

      it 'returns an empty array for non-existent route' do
        expect(result).to eq(nil)
      end
    end
  end
end
