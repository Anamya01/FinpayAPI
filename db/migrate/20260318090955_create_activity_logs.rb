class CreateActivityLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_logs do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :action
      t.jsonb :metadata

      t.timestamps
    end
  end
end
