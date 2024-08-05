# frozen_string_literal: true

FactoryBot.define do
  factory :exchange_rate, class: 'ShippingCalculator::Models::ExchangeRate' do
    date { '2024-03-01' }
    rates { { 'USD' => '1.19', 'GBP' => '0.85' } }

    initialize_with { new(attributes) }
  end
end
