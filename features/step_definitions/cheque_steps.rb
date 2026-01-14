Dado('que existe um borderô com os seguintes cheques:') do |table|
  bordero = Bordero.create!(
    exchange_date: Date.today,
    monthly_interest: 2.5
  )

  table.hashes.each do |row|
    bordero.cheques.create!(
      value: row['value'].to_f,
      due_date: Date.parse(row['due_date']),
      processing_days: row['processing_days'].to_i,
      status: 'awaiting'
    )
  end
end

Então('a resposta JSON deve conter uma lista com {int} cheque(s)') do |quantidade|
  expect(@json_response).to be_an(Array)
  expect(@json_response.length).to eq(quantidade)
end

Então('todos os cheques devem ter status {string}') do |status_esperado|
  expect(@json_response).to be_an(Array)
  @json_response.each_with_index do |cheque, index|
    expect(cheque['status']).to eq(status_esperado), "Cheque #{index + 1}: expected status '#{status_esperado}', got '#{cheque['status']}'"
  end
end

Então('a tabela de cheques deve conter os registros com:') do |table|
  cheques = Bordero.last.cheques.order(:created_at).to_a
  expect(cheques.count).to eq(table.hashes.length)

  table.hashes.each_with_index do |expected_row, index|
    cheque = cheques[index]
    expected_row.each do |field, expected_value|
      actual_value = field == 'value' ? cheque.value.to_f.to_s : cheque.send(field).to_s
      expect(actual_value).to eq(expected_value)
    end
  end
end
