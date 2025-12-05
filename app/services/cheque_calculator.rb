class ChequeCalculator
  attr_reader :valor_cheque, :data_vencimento, :dias_compensacao, :dias_em_espera

  def initialize(valor_cheque:, data_vencimento:, dias_compensacao:, data_troca:)
    @valor_cheque = valor_cheque
    @data_vencimento = Date.parse(data_vencimento)
    @dias_compensacao = dias_compensacao
    @data_troca = Date.parse(data_troca)

    calcular
  end

  def to_h
    {
      valor_cheque: @valor_cheque,
      data_vencimento: @data_vencimento,
      dias_compensacao: @dias_compensacao,
      dias_em_espera: @dias_em_espera
    }
  end

  private

  def calcular
    @dias_em_espera = (@data_vencimento - @data_troca + @dias_compensacao).to_i
  end
end
