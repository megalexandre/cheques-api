require "test_helper"

class ChequesIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @cliente = Cliente.create!(
      nome: "João Silva",
      documento: "12345678900",
      telefone: "(11) 98765-4321",
      email: "joao@example.com"
    )

    @bordero = Bordero.create!(
      cliente: @cliente,
      data_troca: Date.today,
      numero_bordero: "BOR-001",
      juros_mensal: BigDecimal("2.5"),
      valor_tac: BigDecimal("50.00"),
      observacao: "Borderô de teste"
    )

    @cheque = Cheque.create!(
      bordero: @bordero,
      holder: "Maria Santos",
      valor_cheque: BigDecimal("1000.00"),
      data_vencimento: Date.today + 30.days,
      bank: "Banco do Brasil",
      numero_agencia: "1234-5",
      numero_cheque: "000001",
      dias_compensacao: 2
    )
  end

  test "should get index" do
    get cheques_url, as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_not_empty json_response
  end

  test "should show cheque" do
    get cheque_url(@cheque), as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal @cheque.id, json_response["id"]
    assert_equal "Maria Santos", json_response["holder"]
  end

  test "should create cheque" do
    assert_difference("Cheque.count", 1) do
      post cheques_url, params: {
        cheque: {
          bordero_id: @bordero.id,
          holder: "Pedro Oliveira",
          valor_cheque: "1500.50",
          data_vencimento: Date.today + 45.days,
          bank: "Itaú",
          numero_agencia: "5678-9",
          numero_cheque: "000002",
          dias_compensacao: 2
        }
      }, as: :json
    end

    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal "Pedro Oliveira", json_response["holder"]
    assert_equal "1500.5", json_response["valor_cheque"]
  end

  test "should update cheque" do
    patch cheque_url(@cheque), params: {
      cheque: {
        holder: "Maria Santos Atualizada"
      }
    }, as: :json

    assert_response :success
    @cheque.reload
    assert_equal "Maria Santos Atualizada", @cheque.holder
  end

  test "should destroy cheque" do
    assert_difference("Cheque.count", -1) do
      delete cheque_url(@cheque), as: :json
    end

    assert_response :no_content
  end

  test "should not create cheque without required fields" do
    assert_no_difference("Cheque.count") do
      post cheques_url, params: {
        cheque: {
          bordero_id: @bordero.id,
          holder: "Teste"
          # Faltando campos obrigatórios
        }
      }, as: :json
    end

    assert_response :unprocessable_entity
  end

  test "should calculate dias_a_decorrer correctly" do
    cheque = Cheque.create!(
      bordero: @bordero,
      holder: "Teste Calculo",
      valor_cheque: BigDecimal("2000.00"),
      data_vencimento: @bordero.data_troca + 30.days,
      bank: "Bradesco",
      numero_agencia: "9999-9",
      numero_cheque: "999999",
      dias_compensacao: 2
    )

    # 30 dias - 2 dias de compensação = 28 dias
    assert_equal 28, cheque.dias_a_decorrer
  end

  test "should calculate valor_juros correctly" do
    cheque = Cheque.create!(
      bordero: @bordero,
      holder: "Teste Juros",
      valor_cheque: BigDecimal("1000.00"),
      data_vencimento: @bordero.data_troca + 30.days,
      bank: "Santander",
      numero_agencia: "8888-8",
      numero_cheque: "888888",
      dias_compensacao: 0
    )

    # Com juros de 2.5% ao mês e 30 dias
    assert cheque.valor_juros > 0
    assert_kind_of BigDecimal, cheque.valor_juros
  end

  test "should calculate valor_iof correctly" do
    cheque = Cheque.create!(
      bordero: @bordero,
      holder: "Teste IOF",
      valor_cheque: BigDecimal("1000.00"),
      data_vencimento: @bordero.data_troca + 30.days,
      bank: "Caixa",
      numero_agencia: "7777-7",
      numero_cheque: "777777",
      dias_compensacao: 0
    )

    iof = cheque.valor_iof
    assert iof > 0
    assert_kind_of BigDecimal, iof
    
    # IOF deve estar entre limites razoáveis (0.38% + dias * 0.0082%)
    assert iof < cheque.valor_cheque * BigDecimal("0.01") # Menos de 1% do valor
  end

  test "should calculate valor_receber correctly" do
    cheque = Cheque.create!(
      bordero: @bordero,
      holder: "Teste Receber",
      valor_cheque: BigDecimal("1000.00"),
      data_vencimento: @bordero.data_troca + 30.days,
      bank: "Banco Inter",
      numero_agencia: "6666-6",
      numero_cheque: "666666",
      dias_compensacao: 0
    )

    valor_receber = cheque.valor_receber
    
    # Valor a receber deve ser menor que o valor do cheque
    assert valor_receber < cheque.valor_cheque
    
    # Deve ser igual a: valor_cheque - juros - iof
    expected = cheque.valor_cheque - cheque.valor_juros - cheque.valor_iof
    assert_equal expected, valor_receber
  end
end
