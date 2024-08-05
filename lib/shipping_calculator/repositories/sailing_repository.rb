module ShippingCalculator
  module Repositories
    class SailingRepository
      def initialize(sailings)
        @sailings = sailings
      end

      def find_direct_routes(origin, destination)
        @sailings.select { |s| s.origin_port == origin && s.destination_port == destination }
      end

      def find_all_routes(origin, destination, include_indirect: true, max_stops: 1)
        direct_routes = find_direct_routes(origin, destination).map { |s| [s] }
        return direct_routes unless include_indirect

        routes = direct_routes.dup
        current_routes = find_sailings_from(origin).map { |s| [s] }

        max_stops.times do
          next_routes = []
          current_routes.each do |route|
            last_sailing = route.last
            connecting_sailings = find_connecting_sailings(last_sailing)

            connecting_sailings.each do |connecting_sailing|
              new_route = route + [connecting_sailing]
              next_routes << new_route
              routes << new_route if connecting_sailing.destination_port == destination
            end
          end
          current_routes = next_routes
          break if current_routes.empty?
        end

        routes.uniq
      end

      private

      def find_sailings_from(origin)
        @sailings.select { |s| s.origin_port == origin }
      end

      def find_connecting_sailings(sailing)
        @sailings.select { |s| s.origin_port == sailing.destination_port && s.departure_date >= sailing.arrival_date }
      end
    end
  end
end
