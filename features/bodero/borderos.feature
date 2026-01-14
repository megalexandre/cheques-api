# language: pt

Funcionalidade: Borderô

  Cenário: Salvar um borderô

    Quando eu enviar um POST para "/borderos" com o JSON:
    """
    {
        "exchange_date": "2026-01-07",
        "monthly_interest": 7,
        "cheques": [
            {
                "value": 2140.00,
                "due_date": "2026-02-06",
                "processing_days": 2
            },
            {
                "value": 3438.00,
                "due_date": "2026-02-10",
                "processing_days": 2
            }
        ]
    }
    """
    Então a resposta deve ser 201
    E a tabela de borderôs deve conter o registro com:
      | exchange_date    | 2026-01-07       |
      | monthly_interest | 7.0              |

    E a tabela de cheques deve conter os registros com:
      | value  | due_date       | processing_days   | 
      | 2140.0 | 2026-02-06     | 2                 |
      | 3438.0 | 2026-02-10     | 2                 |
   