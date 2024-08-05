require 'spec_helper'

RSpec.describe ShippingCalculator::Repositories::SailingRepository do
  let(:sailing1) do
    build(:sailing, origin_port: 'CNSHA', destination_port: 'NLRTM')
  end

  let(:sailing2) do
    build(:sailing, origin_port: 'CNSHA', destination_port: 'NLRTM')
  end

  let(:sailing3) do
    build(:sailing, origin_port: 'CNSHA', destination_port: 'NLRTM')
  end

  let(:sailings) { [sailing1, sailing2, sailing3] }
  let(:sailing_repository) { described_class.new(sailings) }

  describe '#find_direct_routes' do
    it 'returns a list of direct routes' do
      expect(sailing_repository.find_direct_routes('CNSHA', 'NLRTM')).to eq([sailing1, sailing2, sailing3])
    end
  end
end
