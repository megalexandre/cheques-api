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
