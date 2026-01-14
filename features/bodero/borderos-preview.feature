# language: pt

Funcionalidade: Borderô

  Contexto:
    Dado que a data atual é "2025-10-01 00:00:00"
  
  Cenário: Calcular um borderô para 31 dias

    # valor 10 mil reais com juros mensal de 2,5% para o mes de janeiro de 2026 
    # para o vencimento de dias 29 + 2 dias úteis de processamento = 31 dias
    # como dia 31 é final de semana, o vencimento efetivo será dia 02/02/2026
    
    Dado que a data atual é "2026-01-01 00:00:00"
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
      """
        {
            "exchange_date": "2026-01-01",
            "monthly_interest": 2.5,
            "cheques": [
                {
                    "value": 10000.00,
                    "due_date": "2026-01-29",
                    "processing_days": 2
                }
            ]
        }
      """
    Então a resposta deve ser 200
    E todos os cheques devem estar em dias úteis
    E a resposta JSON deve conter:
    """
    {
      "exchange_date": "2026-01-01",
      "monthly_interest": "2.5",
      "cheques": [
          {
              "value": "10000.0",
              "due_date": "2026-01-29",
              "effective_due_date": "2026-02-02",
              "processing_days": 2,
              "days_count": 32,
              "total_interest": "2.66667",
              "paid_for_exchange": "266.67",
              "amount_to_receive": "9733.33"
          }
      ],
      "total_paid": "10000.0",
      "total_value": "9733.33"
    }
    """


  Cenário: Calcular um borderô com data caindo em final de semana

    o dia de compensação precisa ser em dias uteis!

    Quando eu enviar um POST para "/borderos/preview" com o JSON:
      """
        {
            "exchange_date": "2025-11-27",
            "monthly_interest": 2.5,
            "cheques": [
                {
                    "value": 3000.00,
                    "due_date": "2026-01-15",
                    "processing_days": 0
                }
            ]
        }
      """
    Então a resposta deve ser 200
    E todos os cheques devem estar em dias úteis
    E a resposta JSON deve conter:
    """
    {
        "exchange_date":"2025-11-27", 
        "monthly_interest":"2.5",
        "total_paid":"3000.0",
        "total_value":"2877.5",
        "cheques":
        [
            {
                "value":"3000.0",
                "due_date":"2026-01-15",
                "effective_due_date":"2026-01-15",
                "processing_days":0,
                "days_count":49,
                "total_interest":"4.08333",
                "paid_for_exchange":"122.5",
                "amount_to_receive":"2877.5"
            }
        ] 
    }
    """


  Cenário: Calcular um borderô com data caindo em feriado

    o dia de compensação precisa ser em dias uteis!

    Dado que "2026-01-19" é um feriado bancário
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
      """
        {
            "exchange_date": "2025-11-27",
            "monthly_interest": 2.5,
            "cheques": [
                {
                    "value": 3000.00,
                    "due_date": "2026-01-15",
                    "processing_days": 2
                }
            ]
        }
      """
    Então a resposta deve ser 200
    E todos os cheques devem estar em dias úteis
    E a resposta JSON deve conter:
    """
    {
        "exchange_date":"2025-11-27", 
        "monthly_interest":"2.5",
        "total_paid":"3000.0",
        "total_value":"2865.0",
        "cheques":
        [
            {
                "value":"3000.0",
                "due_date":"2026-01-15",
                "effective_due_date":"2026-01-20",
                "processing_days":2,
                "days_count":54,
                "total_interest":"4.5",
                "paid_for_exchange":"135.0",
                "amount_to_receive":"2865.0"
            }
        ] 
    }
    """


  Cenário: Calcular um borderô quando há feriados entres os dias de processamento

    o dia de vencimento precisa ser em dia util mas somente ele, 
    os dias de processamento PRECISAM ser todos dias uteis!

    Dado que "2026-01-01" é um feriado bancário
    Quando eu enviar um POST para "/borderos/preview" com o JSON:
      """
        {
            "exchange_date": "2026-01-01",
            "monthly_interest": 2.5,
            "cheques": [
                {
                    "value": 1000.00,
                    "due_date": "2026-01-23",
                    "processing_days": 2
                }
            ]
        }
      """
    Então a resposta deve ser 200
    E todos os cheques devem estar em dias úteis
    E a resposta JSON deve conter:
    """
    {
        "exchange_date":"2026-01-01", 
        "monthly_interest":"2.5",
        "total_paid":"1000.0",
        "total_value":"978.33",
        "cheques":
        [
            {
                "value":"1000.0",
                "due_date":"2026-01-23",
                "effective_due_date":"2026-01-27",
                "processing_days":2,
                "days_count":26,
                "total_interest":"2.16667",
                "paid_for_exchange":"21.67",
                "amount_to_receive":"978.33"
            }
        ] 
    }
    """
