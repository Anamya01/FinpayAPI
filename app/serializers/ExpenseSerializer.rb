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
  many :receipts, resource: ReceiptSerializer
end
