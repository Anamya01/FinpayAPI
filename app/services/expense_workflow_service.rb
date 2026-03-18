class ExpenseWorkflowService
  def initialize(expense, user)
    @expense = expense
    @user = user
  end

  def approve
    return invalid_transition("Cannot approve") unless @expense.may_approve?

    @expense.approve!
    mark_reviewed
    audit_log("approved")

    success("Expense approved")
  end

  def reject
    return invalid_transition("Cannot reject") unless @expense.may_reject?

    @expense.reject!
    mark_reviewed
    audit_log("rejected")

    success("Expense rejected")
  end

  def reimburse
    return invalid_transition("Cannot reimburse") unless @expense.may_reimburse?

    @expense.reimburse!
    mark_reviewed
    audit_log("reimbursed")

    success("Expense reimbursed")
  end

  def archive
    if @expense.pending?
      @expense.destroy!
      audit_log("deleted")
      return success("Expense deleted (was pending)")
    end

    return invalid_transition("Cannot archive") unless @expense.may_archive?

    @expense.archive!
    mark_reviewed

    success("Expense archived")
  end

  private

  def mark_reviewed
    @expense.update(reviewed_by_id: @user.id)
  end

  def success(message)
    { status: :ok, message: message }
  end

  def invalid_transition(message)
    { status: :unprocessable_entity, message: message }
  end

  def audit_log(action, metadata = {})
    AuditLogJob.perform_async(
      @expense.id,
      @user.id,
      action,
      metadata
       )
  end
end
