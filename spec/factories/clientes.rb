FactoryBot.define do
  factory :cliente do
    nome { Faker::Name.name }
    documento { Faker::Number.number(digits: 11).to_s }
    telefone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
  end
end
