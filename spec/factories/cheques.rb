FactoryBot.define do
  factory :cheque do
    association :bordero
    holder { Faker::Name.name }
    valor_cheque { BigDecimal("1000.00") }
    data_vencimento { Date.today + 30.days }
    bank { Faker::Bank.name }
    numero_agencia { "#{Faker::Number.number(digits: 4)}-#{Faker::Number.digit}" }
    numero_cheque { Faker::Number.number(digits: 6).to_s }
    dias_compensacao { 2 }
  end
end
