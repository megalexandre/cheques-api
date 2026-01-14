class ChequesController < ApplicationController
  before_action :set_cheque, only: %i[ show update destroy ]

  # GET /cheques
  def index
    @cheques = Cheque.all
    render json: @cheques
  end

  # GET /cheques/1
  def show
    render json: @cheque
  end

  # POST /cheques
  def create
    cheques = build_cheques

    if valid_cheques?
      Cheque.transaction do
        cheques.each(&:save!)
      end

      render json: cheques, status: :created

    else
      errors = cheques.map.with_index do |cheque, index|
        { index: index, errors: cheque.errors } unless cheque.valid?
      end.compact
        render json: { errors: errors }, status: :unprocessable_entity
    end
  end


  # DELETE /cheques/1
  def destroy
    @cheque.destroy!
  end

  private
    def valid_cheques?
        build_cheques.all?(&:valid?)
    end

    def build_cheques
      params[:cheques].map do |cheque_data|
        Cheque.new(cheque_data.permit(:bordero_id, :due_date, :processing_days, :amount))
      end
    end


    def set_cheque
      @cheque = Cheque.find(params[:id])
    end

    def cheque_params
      params.require(:cheque).permit(:bordero_id, :due_date, :processing_days, :amount)
    end
end
