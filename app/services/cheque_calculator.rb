class ChequeCalculator
  attr_reader :valor_cheque, :data_vencimento, :dias_compensacao, :quantidade_de_dias, :juros_mensal

  def initialize(valor_cheque:, data_vencimento:, dias_compensacao:, data_troca:, juros_mensal:)
    @valor_cheque = valor_cheque
    @data_vencimento = Date.parse(data_vencimento)
    @dias_compensacao = dias_compensacao
    @data_troca = Date.parse(data_troca)
    @juros_mensal = juros_mensal
  end

  def to_h
    {
      valor_cheque: @valor_cheque,
      data_vencimento: @data_vencimento,
      dias_compensacao: @dias_compensacao,
      quantidade_de_dias:,
      total_juros:,
      pago_pela_troca:,
      valor_a_receber:
    }
  end

  private

  def quantidade_de_dias
    (@data_vencimento - @data_troca + @dias_compensacao).to_i
  end

  def total_juros
    (juros_mensal / 30.0) * quantidade_de_dias
  end

  def pago_pela_troca
    valor_cheque * total_juros / 100.0
  end

  def valor_a_receber
    valor_cheque - pago_pela_troca
  end
end
