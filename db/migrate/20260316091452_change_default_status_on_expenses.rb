class ChangeDefaultStatusOnExpenses < ActiveRecord::Migration[8.1]
  def change
    change_column_default :expenses, :status, from: nil, to: "pending"
  end
end
