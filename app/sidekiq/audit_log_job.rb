class AuditLogJob
  include Sidekiq::Job

  def perform(tenant, expense_id, user_id, action, metadata = {})
    Apartment::Tenant.switch(tenant) do
      expense = Expense.find_by(id: expense_id)
      user = User.find_by(id: user_id)
      return unless expense && user

      ActivityLog.create!(
        expense: expense,
        user: user,
        action: action,
        metadata: metadata
      )
    end
  end
end
