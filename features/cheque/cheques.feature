# language: pt

Funcionalidade: Cheques

  Cenário: Listar cheques
    Quando eu enviar um GET para "/cheques"
    Então a resposta deve ser 200
    E a resposta JSON deve conter uma lista com 0 cheques

  Cenário: Listar cheques
    Dado que existe um borderô com os seguintes cheques:
      | value  | due_date   | processing_days |
      | 1000.0 | 2026-02-15 | 2               |
      | 2000.0 | 2026-02-20 | 3               |
      | 1500.0 | 2026-02-25 | 2               |
    Quando eu enviar um GET para "/cheques"
    Então a resposta deve ser 200
    E a resposta JSON deve conter uma lista com 3 cheques
    E todos os cheques devem ter status "awaiting"
