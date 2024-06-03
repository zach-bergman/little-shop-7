FactoryBot.define do
  factory :merchant do
    name { Faker::Company.name }
    status { Faker::Number.within(range: 0..1) }
  end
end