# language: pt

Dado('que existe um cliente cadastrado') do
  @cliente = create(:cliente)
end

Quando('eu criar um borderô com os seguintes dados:') do |table|
  data = table.rows_hash
  @bordero = create(:bordero,
    cliente: @cliente,
    data_troca: Date.parse(data['data_troca']),
    numero_bordero: data['numero_bordero'],
    juros_mensal: BigDecimal(data['juros_mensal']),
    valor_tac: BigDecimal(data['valor_tac'])
  )
end

Quando('adicionar os seguintes cheques ao borderô:') do |table|
  table.hashes.each do |row|
    create(:cheque,
      bordero: @bordero,
      holder: row['holder'],
      valor_cheque: BigDecimal(row['valor_cheque']),
      data_vencimento: Date.parse(row['data_vencimento']),
      bank: row['bank'],
      numero_agencia: row['numero_agencia'],
      numero_cheque: row['numero_cheque'],
      dias_compensacao: row['dias_compensacao'].to_i
    )
  end
end

Então('o borderô deve ter {int} cheques') do |quantidade|
  expect(@bordero.cheques.count).to eq(quantidade)
end

Então('o valor total dos cheques deve ser {string}') do |valor_esperado|
  total = @bordero.valor_total_cheques
  expect(total.to_s).to eq(valor_esperado)
end

# Cenário: Calcular valores do borderô
Dado('que existe um borderô com os seguintes dados:') do |table|
  data = table.rows_hash
  @bordero = create(:bordero,
    cliente: @cliente,
    data_troca: Date.parse(data['data_troca']),
    numero_bordero: "BOR-#{rand(1000..9999)}",
    juros_mensal: BigDecimal(data['juros_mensal']),
    valor_tac: BigDecimal(data['valor_tac'])
  )
end

Dado('o borderô tem um cheque:') do |table|
  data = table.rows_hash
  @cheque = create(:cheque,
    bordero: @bordero,
    holder: "Teste",
    valor_cheque: BigDecimal(data['valor_cheque']),
    data_vencimento: Date.parse(data['data_vencimento']),
    bank: "Banco Teste",
    numero_agencia: "0001",
    numero_cheque: "123456",
    dias_compensacao: data['dias_compensacao'].to_i
  )
end

Quando('eu calcular os valores do borderô') do
  @valor_total_juros = @bordero.valor_total_juros
  @valor_total_iof = @bordero.valor_total_iof
  @valor_liquido = @bordero.valor_liquido_receber
end

Então('o borderô deve ter valor total de juros maior que {int}') do |valor|
  expect(@valor_total_juros).to be > valor
end

Então('o borderô deve ter valor total de IOF maior que {int}') do |valor|
  expect(@valor_total_iof).to be > valor
end

Então('o valor líquido a receber deve ser menor que {string}') do |valor|
  expect(@valor_liquido).to be < BigDecimal(valor)
end
