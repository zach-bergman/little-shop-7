FactoryBot.define do
  factory :invoice_item do
    association :invoice
    association :item
    quantity { Faker::Number.within(range: 1..50)}
    unit_price { Faker::Commerce.price(range: 1..100) }
    status { Faker::Number.within(range: 0..2) }
  end
end