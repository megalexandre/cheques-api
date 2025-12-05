class CreateCheques < ActiveRecord::Migration[8.1]
  def change
    create_table :cheques, id: :uuid do |t|
      t.uuid :bordero_id, null: false
      t.decimal :valor_cheque, precision: 10, scale: 2, null: false
      t.date :data_vencimento, null: false
      t.integer :dias_compensacao, null: false

      t.timestamps
    end

    add_foreign_key :cheques, :borderos
    add_index :cheques, :bordero_id
  end
end
