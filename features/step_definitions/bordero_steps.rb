Então('o borderô deve ter {int} cheque(s)') do |quantidade|
  bordero = Bordero.last
  expect(bordero).not_to be_nil
  expect(bordero.cheques.count).to eq(quantidade)
end

Então('o total do bordero deve ser {float}') do |total_esperado|
  expect(@json_response['valor_cheques_total']).to eq(total_esperado)
end

Então('o total pago pela troca deve ser {float}') do |total_esperado|
  total_pago = @json_response['cheques'].sum { |cheque| cheque['pago_pela_troca'] }
  expect(total_pago).to eq(total_esperado)
end

Então('todos os cheques devem estar em dias úteis') do
  cheques = @json_response['cheques']

  cheques.each_with_index do |cheque, index|
    effective_due_date = Date.parse(cheque['effective_due_date'])

    expect(effective_due_date.saturday?).to be(false), "Cheque #{index + 1}: effective_due_date #{effective_due_date} is Saturday"
    expect(effective_due_date.sunday?).to be(false), "Cheque #{index + 1}: effective_due_date #{effective_due_date} is Sunday"

    expect(BankHoliday.exists?(date: effective_due_date)).to be(false), "Cheque #{index + 1}: effective_due_date #{effective_due_date} is a bank holiday"
  end
end
