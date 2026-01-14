class BorderosController < ApplicationController
  def create
    bordero_form = BorderoPreviewForm.new(params)

    if bordero_form.valid?
      bordero = CreateBordero.new(bordero_form.to_create).call
      render json: { id: bordero.id }, status: :created
    else
      render json: { errors: bordero_form.errors.full_messages }, status: :bad_request
    end
  end
end
