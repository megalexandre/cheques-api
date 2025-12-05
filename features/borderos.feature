# language: pt

Funcionalidade: Borderô
  
  Cenário: Calcular um borderô

    Quando eu enviar um POST para "/borderos/calculate" com o JSON:
    """
    {
      "data_troca": "2025-11-27",
      "juros_mensal": 2.5,
      "cheques": 
      [
          {
              "data_vencimento": "2026-01-13",
              "valor_cheque": 5000.00,
              "dias_compensacao": 2
          }
      ]
    }
    """
    Então a resposta deve ser 200
    E o total do bordero deve ser 5000.0
    E a resposta JSON deve conter:
    """
    {
      "data_troca": "2025-11-27",
      "juros_mensal": 2.5,
      "cheques": [
          {
              "valor_cheque": 5000.0,
              "data_vencimento": "2026-01-13",
              "dias_compensacao": 2,
              "quantidade_de_dias": 49,
              "total_juros": 4.083333333333333,
              "pago_pela_troca": 204.16666666666663,
              "valor_a_receber": 4795.833333333333
          }
      ],
      "valor_cheques_total": 5000.0
    }
    """

