# language: pt

Funcionalidade: Borderô
  
  Cenário: Criar um borderô

    Quando eu enviar um POST para "/borderos/calculate" com o JSON:
    """
    {
      "data_troca": "2025-11-27",
      "juros_mensal": 2.5,
      "cheques": 
      [
          {
              "data_vencimento": "2026-01-13",
              "valor_cheque": 500.00,
              "dias_compensacao": 2
          }
      ]
    }
    """
    Então a resposta deve ser 200
    E a resposta JSON deve conter:
    """
    {
      "data_troca": "2025-11-27",
      "juros_mensal": 2.5,
      "valor_cheques_total": 500.0,
      "cheques": [
        {
          "valor_cheque": 500.0,
          "data_vencimento": "2026-01-13",
          "dias_compensacao": 2,
          "dias_em_espera": 49
        }
      ]
    }
    """

