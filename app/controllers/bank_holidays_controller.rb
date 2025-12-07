class BankHolidaysController < ApplicationController
  before_action :set_bank_holiday, only: [ :show, :update, :destroy ]

  # GET /bank_holidays
  def index
    @bank_holidays = BankHoliday.all
    render json: @bank_holidays
  end

  # GET /bank_holidays/:id
  def show
    render json: @bank_holiday
  end

  # POST /bank_holidays
  def create
    @bank_holiday = BankHoliday.new(bank_holiday_params)

    if @bank_holiday.save
      render json: @bank_holiday, status: :created
    else
      render json: { errors: @bank_holiday.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bank_holidays/:id
  def update
    if @bank_holiday.update(bank_holiday_params)
      render json: @bank_holiday
    else
      render json: { errors: @bank_holiday.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /bank_holidays/:id
  def destroy
    @bank_holiday.destroy
    head :no_content
  end

  private

  def set_bank_holiday
    @bank_holiday = BankHoliday.find(params[:id])
  end

  def bank_holiday_params
    params.require(:bank_holiday).permit(:date)
  end
end
