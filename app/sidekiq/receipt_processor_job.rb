class ReceiptProcessorJob
  include Sidekiq::Job

  def perform(tenant, expense_id)
    Apartment::Tenant.switch(tenant) do
      expense = Expense.find_by(id: expense_id)
      return unless expense

      expense.receipts.each do |receipt|
        Rails.logger.info "Processing #{receipt.filename}"
      end
    end
  end
end
