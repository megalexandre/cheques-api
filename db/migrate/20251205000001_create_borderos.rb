class CreateBorderos < ActiveRecord::Migration[8.1]
  def change
    enable_extension 'pgcrypto'

    create_table :borderos, id: :uuid do |t|
      t.date :data_troca, null: false
      t.decimal :juros_mensal, precision: 10, scale: 4, null: false

      t.timestamps
    end
  end
end
