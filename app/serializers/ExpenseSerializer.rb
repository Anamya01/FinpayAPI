class ExpenseSerializer
  include Alba::Resource

  attributes :id,
             :name,
             :amount,
             :description,
             :date,
             :status,
             :submitted_at,
             :approved_at

  one :category, resource: CategorySerializer
  many :receipts, resource: ReceiptSerializer

  attribute :user_id do |expense|
    expense.user_id
  end
end
