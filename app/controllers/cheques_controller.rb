class ChequesController < ApplicationController
  before_action :set_cheque, only: %i[ show ]

  # GET /cheques
  def index
    @cheques = Cheque.all
    render json: @cheques
  end

  # GET /cheques/1
  def show
    render json: @cheque
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
