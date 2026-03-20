class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!, only: [ :approve, :reject, :reimburse, :archive ]
  def index
    filtered_expenses = filter_expenses(base_scope)
                                      .page(params[:page])
                                      .per(params[:per_page] || 10)
    json_response(
      ExpenseSerializer.new(filtered_expenses),
      :ok,
      nil,
      pagination_meta(filtered_expenses)
    )
  end

  def show
    json_response(ExpenseSerializer.new(expense))
  end

  def create
    new_expense = current_user.expenses.new(expense_params)
    new_expense.save!
    AuditLogJob.perform_async(new_expense.id, current_user.id, "created")
    ReceiptProcessorJob.perform_async(new_expense.id)
    json_response(ExpenseSerializer.new(new_expense).serialize, :created)
  end

  def update
    expense.update!(expense_params)
      if params[:expense][:receipts].present?
        ReceiptProcessorWorker.perform_async(expense.id)
      end
    json_response(ExpenseSerializer.new(expense).serialize)
  end

  def destroy
    expense.destroy
    head :no_content
  end

  def approve
    result = ExpenseWorkflowService.new(expense, current_user).approve
    json_response(nil, result[:status], result[:message])
  end

  def reject
    result = ExpenseWorkflowService.new(expense, current_user).reject
    json_response(nil, result[:status], result[:message])
  end

  def reimburse
    result = ExpenseWorkflowService.new(expense, current_user).reimburse
    json_response(nil, result[:status], result[:message])
  end

  def archive
    result = ExpenseWorkflowService.new(expense, current_user).archive
    json_response(nil, result[:status], result[:message])
  end

  private

  def expense
    @expense ||= if current_user.admin?
                Expense.find(params[:id])
    else
                current_user.expenses.find(params[:id])
    end
  end

  def base_scope
    scope = current_user.admin? ? Expense.unarchived : current_user.expenses
    scope.includes(:category).with_attached_receipts.tap do |s|
      s.includes(:user) if current_user.admin?
    end
  end

  def filter_expenses(scope)
    ExpenseFilter.new(scope, filter_params).call
  end

  def authorize_admin!
    return if current_user.admin?
    error_response("Unauthorized", :forbidden)
  end

  def expense_params
    params.require(:expense).permit(
      :name,
      :amount,
      :description,
      :date,
      :category_id,
      receipts: []
    )
  end
  def filter_params
    params.permit(:category_id, :start_date, :end_date, :status)
  end
end
