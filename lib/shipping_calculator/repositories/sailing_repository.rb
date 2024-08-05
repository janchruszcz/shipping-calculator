module ShippingCalculator
  module Repositories
    class SailingRepository
      def initialize(sailings)
        @sailings = sailings
      end

      def find_direct_sailings(origin, destination)
        @sailings.select { |s| s.origin_port == origin && s.destination_port == destination }
      end

      def find_all_routes(origin, destination)
        direct_routes = find_direct_sailings(origin, destination)
        indirect_routes = find_indirect_routes(origin, destination)
      end
    end
  end
end
