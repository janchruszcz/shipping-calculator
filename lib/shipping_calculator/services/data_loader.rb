module ShippingCalculator
  module Services
    class DataLoader
      def self.load(file_path)
        data = JSON.parse(File.read(file_path), symbolize_names: true)

        {
          sailings: load_sailings(data[:sailings]),
          rates: load_rates(data[:rates]),
          exchange_rates: load_exchange_rates(data[:exchange_rates])
        }
      end

      private

      def load_sailings(data)
        data.map { |item| ShippingCalculator::Models::Sailing.new(item) }
      end

      def load_rates(data)
        data.map { |item| ShippingCalculator::Models::Rate.new(item) }
      end

      def load_exchange_rates(data)
        data.map { |item| ShippingCalculator::Models::ExchangeRate.new(item) }
      end
    end
  end
end
