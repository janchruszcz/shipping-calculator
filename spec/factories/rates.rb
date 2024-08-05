# frozen_string_literal: true

FactoryBot.define do
  factory :rate, class: 'ShippingCalculator::Models::Rate' do
    sailing_code { 'ABCDE' }
    rate { 100 }
    rate_currency { 'EUR' }

    initialize_with { new(attributes) }
  end
end
