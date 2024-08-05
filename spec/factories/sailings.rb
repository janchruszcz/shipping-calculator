# frozen_string_literal: true

FactoryBot.define do
  factory :sailing, class: 'ShippingCalculator::Models::Sailing' do
    origin_port { 'CNSHA' }
    destination_port { 'NLRTM' }
    departure_date { '2024-01-01' }
    arrival_date { '2024-01-02' }
    sailing_code { 'CNSHA-NLRTM-20240101' }

    initialize_with { new(attributes) }
  end
end
