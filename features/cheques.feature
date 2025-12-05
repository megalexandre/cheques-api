# language: pt

Funcionalidade: Criar e calcular borderô de cheques
  
  Contexto:
    Dado que existe um cliente cadastrado

  Cenário: Criar borderô completo via POST JSON
    Quando eu enviar um POST para "/borderos" com o JSON:
      """
      {
        "bordero": {
          "data_troca": "2025-01-01",
          "juros_mensal": 4.0,
          "cheques_attributes": [
            {
              "data_vencimento": "2025-02-01",
              "valor_cheque": 1500.00,
              "dias_compensacao": 3
            }
          ]
        }
      }
      """
    Então a resposta deve ser 201

    E o borderô deve ter 1 cheque
    E o valor total dos cheques deve ser 1500.00
    E o valor total de juros deve ser maior que 0
    E o valor total de IOF deve ser maior que 0
    E o valor líquido a receber deve estar calculado

