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

      def self.load_sailings(data)
        data.map { |item| ShippingCalculator::Models::Sailing.new(item) }
      end

      def self.load_rates(data)
        data.map { |item| ShippingCalculator::Models::Rate.new(item) }
      end

      def self.load_exchange_rates(data)
        data.map do |date, rates|
          ShippingCalculator::Models::ExchangeRate.new({ date:, rates: })
        end
      end
    end
  end
end
