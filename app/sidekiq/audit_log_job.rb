class AuditLogJob
  include Sidekiq::Job

  def perform(expense_id, user_id, action, metadata = {})
    expense = Expense.find(expense_id)
    user = User.find(user_id)
    return unless expense && user

    ActivityLog.create!(
      expense: @expense,
      user: @user,
      action: action,
      metadata: metadata
      )
  end
end
