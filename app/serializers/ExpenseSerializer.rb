class ExpenseSerializer
  include Alba::Resource

  attributes :id,
             :user_id,
             :name,
             :amount,
             :description,
             :date,
             :status,
             :submitted_at,
             :approved_at

  one :category, resource: CategorySerializer
  attribute :receipt_urls do |expense|
    if expense.receipts.attached?
      expense.receipts.map do |receipt|
        rails_blob_path(receipt, only_path: true)
      end
    else
      []
    end
  end
end
