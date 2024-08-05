# frozen_string_literal: true

FactoryBot.define do
  factory :exchange_rate, class: 'ShippingCalculator::Models::ExchangeRate' do
    date { '2023-01-01' }
    rates { { 'USD' => '1.19', 'GBP' => '0.75' } }

    initialize_with { new(attributes) }
  end
end
