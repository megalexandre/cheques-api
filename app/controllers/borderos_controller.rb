class BorderosController < ApplicationController

  def create
    render json: CreateBordero.new(bordero_params).call, status: :created
  end

  private

  def bordero_params
    params.require(:bordero).permit(
      :data_troca,
      :juros_mensal,
      cheques_attributes: [
        :valor_cheque,
        :data_vencimento,
        :dias_compensacao
      ]
    )
  end
end
