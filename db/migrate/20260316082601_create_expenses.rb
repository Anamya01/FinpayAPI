class CreateExpenses < ActiveRecord::Migration[8.1]
  def change
    create_table :expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :name
      t.decimal :amount
      t.text :description
      t.string :status
      t.date :date
      t.datetime :submitted_at
      t.datetime :approved_at
      t.bigint :approved_by_id

      t.timestamps
    end
  end
end
