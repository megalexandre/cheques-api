FactoryBot.define do
  factory :bordero do
    association :cliente
    data_troca { Date.today }
    numero_bordero { "BOR-#{Faker::Number.number(digits: 6)}" }
    juros_mensal { BigDecimal("2.5") }
    valor_tac { BigDecimal("50.00") }
    observacao { Faker::Lorem.sentence }
  end
end
