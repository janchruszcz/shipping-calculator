# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ShippingCalculator::Repositories::SailingRepository do
  let(:sailing1) do
    build(:sailing, origin_port: 'CNSHA', destination_port: 'NLRTM', departure_date: '2023-01-01',
                    arrival_date: '2023-01-15')
  end
  let(:sailing2) do
    build(:sailing, origin_port: 'CNSHA', destination_port: 'NLRTM', departure_date: '2023-01-05',
                    arrival_date: '2023-01-20')
  end

  let(:sailing3) do
    build(:sailing, origin_port: 'CNSHA', destination_port: 'SGSIN', departure_date: '2023-01-01',
                    arrival_date: '2023-01-10')
  end

  let(:sailing4) do
    build(:sailing, origin_port: 'SGSIN', destination_port: 'NLRTM', departure_date: '2023-01-12',
                    arrival_date: '2023-01-30')
  end

  let(:sailings) { [sailing1, sailing2, sailing3, sailing4] }
  let(:sailing_repository) { described_class.new(sailings) }

  describe '#find_direct_routes' do
    it 'returns a list of direct routes' do
      expect(sailing_repository.find_direct_routes('CNSHA', 'NLRTM')).to eq([sailing1, sailing2])
    end

    it 'returns an empty array when no direct routes are found' do
      expect(sailing_repository.find_direct_routes('CNSHA', 'USNYC')).to be_empty
    end
  end

  describe '#find_all_routes' do
    context 'when include_indirect is false' do
      it 'returns only direct routes' do
        routes = sailing_repository.find_all_routes('CNSHA', 'NLRTM', include_indirect: false)
        expect(routes).to eq([[sailing1], [sailing2]])
      end
    end

    context 'when include_indirect is true' do
      it 'returns both direct and indirect routes' do
        routes = sailing_repository.find_all_routes('CNSHA', 'NLRTM', include_indirect: true)
        expect(routes).to eq([[sailing1], [sailing2], [sailing3, sailing4]])
      end

      it 'respects the max_stops parameter' do
        routes = sailing_repository.find_all_routes('CNSHA', 'NLRTM', include_indirect: true, max_stops: 0)
        expect(routes).to eq([[sailing1], [sailing2]])
      end

      it 'returns an empty array when no routes are found' do
        routes = sailing_repository.find_all_routes('USNYC', 'AUMEL', include_indirect: true)
        expect(routes).to be_empty
      end
    end
  end

  describe 'private methods' do
    describe '#find_sailings_from' do
      it 'returns sailings from a specific origin' do
        sailings_from_cnsha = sailing_repository.send(:find_sailings_from, 'CNSHA')
        expect(sailings_from_cnsha).to eq([sailing1, sailing2, sailing3])
      end
    end

    describe '#find_connecting_sailings' do
      it 'returns connecting sailings for a given sailing' do
        connecting_sailings = sailing_repository.send(:find_connecting_sailings, sailing3)
        expect(connecting_sailings).to eq([sailing4])
      end

      it 'returns an empty array when no connecting sailings are found' do
        connecting_sailings = sailing_repository.send(:find_connecting_sailings, sailing2)
        expect(connecting_sailings).to be_empty
      end
    end
  end
end
