class AddStatusToCheques < ActiveRecord::Migration[8.1]
  def change
    add_column :cheques, :status, :string, default: 'awaiting', null: false
    add_index :cheques, :status
  end
end
