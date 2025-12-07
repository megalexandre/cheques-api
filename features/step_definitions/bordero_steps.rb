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
  exchange_date = Date.parse(@json_response['exchange_date'])

  cheques.each_with_index do |cheque, index|
    due_date = Date.parse(cheque['due_date'])
    processing_days = cheque['processing_days']

    # Calcula a data alvo (due_date + processing_days)
    target_date = due_date + processing_days

    # Verifica se é final de semana e avança se necessário
    while target_date.saturday? || target_date.sunday?
      target_date += 1
    end

    # Valida que a data ajustada não é final de semana
    expect(target_date.saturday?).to be(false), "Cheque #{index + 1}: target date #{target_date} is Saturday"
    expect(target_date.sunday?).to be(false), "Cheque #{index + 1}: target date #{target_date} is Sunday"

    # Valida que days_count corresponde à data ajustada
    expected_days_count = (target_date - exchange_date).to_i
    actual_days_count = cheque['days_count']
    expect(actual_days_count).to eq(expected_days_count),
      "Cheque #{index + 1}: expected days_count to be #{expected_days_count} but got #{actual_days_count}"
  end
end
