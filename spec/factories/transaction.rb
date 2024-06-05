FactoryBot.define do
  factory :transaction do
    association :invoice
    credit_card_number { Faker::Finance.credit_card(:visa, :mastercard) } # only getting 4 numbers
    credit_card_expiration_date { Faker::Business.credit_card_expiry_date.strftime("%m/%y") }
    result { Faker::Number.within(range: 0..1) }
  end
end