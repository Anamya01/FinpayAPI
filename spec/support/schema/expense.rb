EXPENSE_SCHEMA = {
  type: :object,
  properties: {
    expense: {
      type: :object,
      properties: {
        name: { type: :string },
        amount: { type: :number },
        description: { type: :string },
        date: { type: :string, format: :date },
        category_id: { type: :integer }
      },
      required: %w[name amount date]
    }
  },
  required: [ 'expense' ]
}
