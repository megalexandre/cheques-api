Quando('eu enviar um POST para {string} com o JSON:') do |path, json_string|
  header 'Content-Type', 'application/json'
  post path, json_string
  @last_response = last_response
  @json_response = json_response if last_response.content_type&.include?('application/json')
end

Então('a resposta deve ser {int}') do |status_code|
  expect(@last_response.status).to eq(status_code)
end

Então('a resposta JSON deve conter:') do |json_string|
  expected = JSON.parse(json_string)
  actual = @json_response

  expect(JSON.parse(actual.to_json)).to eq(JSON.parse(expected.to_json))
end
