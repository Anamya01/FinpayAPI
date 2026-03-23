class ExpenseWorkflowService
  def initialize(expense, user)
    @expense = expense
    @user = user
  end

  def approve
    return invalid_transition(:cannot_approve) unless @expense.may_approve?

    @expense.approve!
    mark_reviewed
    audit_log("approved")

    success(:approved)
  end

  def reject
    return invalid_transition(:cannot_reject) unless @expense.may_reject?

    @expense.reject!
    mark_reviewed
    audit_log("rejected")

    success(:rejected)
  end

  def reimburse
    return invalid_transition(:cannot_reimburse) unless @expense.may_reimburse?

    @expense.reimburse!
    mark_reviewed
    audit_log("reimbursed")

    success(:reimbursed)
  end

  def archive
    if @expense.pending?
      @expense.destroy!
      audit_log("deleted")
      return success(:deleted)
    end

    return invalid_transition(:cannot_archive) unless @expense.may_archive?

    @expense.archive!
    mark_reviewed

    success(:archived)
  end

  private

  def mark_reviewed
    @expense.update(reviewed_by_id: @user.id)
  end

  def success(key)
    { status: :ok, message: I18n.t("services.expense_workflow.success.#{key}") }
  end

  def invalid_transition(key)
    { status: :unprocessable_entity, message: I18n.t("services.expense_workflow.errors.#{key}") }
  end

  def audit_log(action, metadata = {})
    AuditLogJob.perform_async(
      Apartment::Tenant.current,
      @expense.id,
      @user.id,
      action,
      metadata
       )
  end
end
