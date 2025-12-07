class ChequeCalculator
  attr_reader :value, :due_date, :processing_days, :days_count, :monthly_interest

  def initialize(value:, due_date:, processing_days:, exchange_date:, monthly_interest:)
    @value = Money.new(value.to_d * 100, "BRL")
    @due_date = due_date.is_a?(Date) ? due_date : Date.parse(due_date.to_s)
    @processing_days = processing_days
    @exchange_date = exchange_date.is_a?(Date) ? exchange_date : Date.parse(exchange_date.to_s)
    @monthly_interest = monthly_interest
  end

  def to_h
    {
      value: @value.to_d,
      due_date: @due_date,
      processing_days: @processing_days,
      days_count:,
      total_interest: total_interest_percentage,
      paid_for_exchange: paid_for_exchange_money.to_d,
      amount_to_receive: amount_to_receive_money.to_d
    }
  end

  private

  def days_count
    target_date = @due_date + @processing_days

    while weekend?(target_date)
      target_date += 1
    end

    (target_date - @exchange_date).to_i
  end

  def weekend?(date)
    date.saturday? || date.sunday?
  end

  def total_interest_percentage
    ((monthly_interest / 30.0) * days_count).round(5)
  end

  def paid_for_exchange_money
    Money.new((@value.to_d * total_interest_percentage / 100.0 * 100).round, "BRL")
  end

  def amount_to_receive_money
    @value - paid_for_exchange_money
  end
end
