class RenameApprovedByToReviewedByInExpenses < ActiveRecord::Migration[8.1]
  def change
    rename_column :expenses, :approved_by_id, :reviewed_by_id
  end
end
