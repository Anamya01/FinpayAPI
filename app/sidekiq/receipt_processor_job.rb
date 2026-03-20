class ReceiptProcessorJob
  include Sidekiq::Job

  def perform(expense_id)
    expense = Expense.find(expense_id)
    return unless expense

    expense.receipts.each do |receipt|
      Rails.logger.info "Processing #{receipt.filename}"
    end
  end
end
