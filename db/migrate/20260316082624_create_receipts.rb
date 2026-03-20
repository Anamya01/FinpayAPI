class CreateReceipts < ActiveRecord::Migration[8.1]
  def change
    create_table :receipts do |t|
      t.references :expense, null: false, foreign_key: true

      t.timestamps
    end
  end
end
