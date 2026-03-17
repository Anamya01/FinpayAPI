class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: [ :show, :update, :destroy ]

  def index
    # to resolv n+1 query issue
    base_scope = if current_user.admin?
                 Expense.includes(:user, :category, receipts: { file_attachment: :blob })
    else
                 current_user.expenses.includes(:category, receipts: { file_attachment: :blob })
    end
    # filtered expense here.
    filtered_expenses = ExpenseFilter.new(base_scope, filter_params).call
                                      .page(params[:page])
                                      .per(params[:per_page] || 10)
    render json: {
      expenses: ExpenseSerializer.new(filtered_expenses),
      meta:  pagination_meta(filtered_expenses) }
  end

  def show
    render json: ExpenseSerializer.new(expense).serialize
  end

  def create
    new_expense = current_user.expenses.new(expense_params)

    if new_expense.save
      render json: ExpenseSerializer.new(new_expense).serialize, status: :created
    else
      render json: { errors: new_expense.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if expense.update(expense_params)
      render json: ExpenseSerializer.new(expense).serialize
    else
      render json: { errors: expense.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    expense.destroy
    head :no_content
  end

  private

  def expense
    @expense ||= if current_user.admin?
                Expense.find(params[:id])
    else
                current_user.expenses.find(params[:id])
    end
  end

  def expense_params
    params.require(:expense).permit(
      :name,
      :amount,
      :description,
      :date,
      :category_id,
      # Allow nesting receipts.
      receipts_attributes: [ :id, :file, :_destroy ]
    )
  end
  def filter_params
    params.permit(:category_id, :start_date, :end_date, :status)
  end
end
