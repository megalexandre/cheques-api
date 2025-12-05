# language: pt

Dado('que existe um cliente cadastrado') do
  @cliente = FactoryBot.create(:cliente)
end

Dado('que existe um borderô criado') do
  @bordero = FactoryBot.create(:bordero, cliente: @cliente)
end

Quando('eu criar um cheque com os seguintes dados:') do |table|
  data = table.rows_hash
  @cheque_params = {
    bordero_id: @bordero.id,
    holder: data['holder'],
    valor_cheque: data['valor_cheque'],
    data_vencimento: Date.today + 30.days,
    bank: data['bank'],
    numero_agencia: data['numero_agencia'],
    numero_cheque: data['numero_cheque'],
    dias_compensacao: data['dias_compensacao'].to_i
  }
  
  post '/cheques', { cheque: @cheque_params }.to_json, { 'CONTENT_TYPE' => 'application/json' }
  @cheque = Cheque.last
end

Então('o cheque deve ser criado com sucesso') do
  expect(last_response.status).to eq(201)
  expect(@cheque).not_to be_nil
end

Então('o cheque deve ter o titular {string}') do |titular|
  expect(@cheque.holder).to eq(titular)
end

Então('o valor do cheque deve ser {string}') do |valor|
  expect(@cheque.valor_cheque.to_s).to eq(valor)
end

# Cenário: Calcular dias a decorrer
Dado('que existe um cheque com vencimento em {int} dias') do |dias|
  @cheque = FactoryBot.create(:cheque,
    bordero: @bordero,
    data_vencimento: @bordero.data_troca + dias.days
  )
end

Dado('o cheque tem {int} dias de compensação') do |dias|
  @cheque.update(dias_compensacao: dias)
end

Quando('eu consultar os dias a decorrer') do
  @dias_a_decorrer = @cheque.dias_a_decorrer
end

Então('o resultado deve ser {int} dias') do |dias_esperados|
  expect(@dias_a_decorrer).to eq(dias_esperados)
end

# Cenário: Calcular valor a receber
Dado('que existe um cheque de R$ {float}') do |valor|
  @cheque = FactoryBot.create(:cheque,
    bordero: @bordero,
    valor_cheque: BigDecimal(valor.to_s)
  )
end

Dado('o vencimento é em {int} dias') do |dias|
  @cheque.update(data_vencimento: @bordero.data_troca + dias.days)
end

Dado('os dias de compensação são {int}') do |dias|
  @cheque.update(dias_compensacao: dias)
end

Quando('eu calcular o valor a receber') do
  @valor_receber = @cheque.valor_receber
end

Então('o valor deve ser menor que R$ {float}') do |valor|
  expect(@valor_receber).to be < BigDecimal(valor.to_s)
end

Então('o valor deve descontar juros e IOF') do
  valor_esperado = @cheque.valor_cheque - @cheque.valor_juros - @cheque.valor_iof
  expect(@valor_receber).to eq(valor_esperado)
end

# Cenário: Listar todos os cheques
Dado('que existem {int} cheques cadastrados') do |quantidade|
  quantidade.times do
    FactoryBot.create(:cheque, bordero: @bordero)
  end
end

Quando('eu listar todos os cheques') do
  get '/cheques'
  @cheques = json_response
end

Então('devo ver {int} cheques na lista') do |quantidade|
  expect(@cheques.count).to eq(quantidade)
end

# Cenário: Atualizar um cheque
Dado('que existe um cheque cadastrado') do
  @cheque = FactoryBot.create(:cheque, bordero: @bordero)
end

Quando('eu atualizar o titular para {string}') do |novo_titular|
  patch "/cheques/#{@cheque.id}", { cheque: { holder: novo_titular } }.to_json, { 'CONTENT_TYPE' => 'application/json' }
  @cheque.reload
end

Então('o titular do cheque deve ser {string}') do |titular_esperado|
  expect(@cheque.holder).to eq(titular_esperado)
end

# Cenário: Excluir um cheque
Quando('eu excluir o cheque') do
  @cheque_id = @cheque.id
  delete "/cheques/#{@cheque.id}"
end

Então('o cheque não deve mais existir') do
  expect(Cheque.find_by(id: @cheque_id)).to be_nil
end
