class CreateBankHolidays < ActiveRecord::Migration[8.1]
  def change
    create_table :bank_holidays do |t|
      t.date :date

      t.timestamps
    end
  end
end
