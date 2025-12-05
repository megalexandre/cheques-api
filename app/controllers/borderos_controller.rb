class BorderosController < ApplicationController
  # POST /borderos
  def create
    render json: CreateBordero.new(bordero_params).call, status: :created
  end

  # POST /borderos/calculate
  def calculate
    render json: CalculateBordero.new(calculate_params).call, status: :ok
  end

  private

  def calculate_params
    params.permit(
      :data_troca,
      :juros_mensal,
      cheques: [
        :valor_cheque,
        :data_vencimento,
        :dias_compensacao
      ]
    ).to_h.deep_symbolize_keys
  end

  def bordero_params
    params.permit(
      :data_troca,
      :juros_mensal,
      cheques: [
        :valor_cheque,
        :data_vencimento,
        :dias_compensacao
      ]
    )
  end
end
