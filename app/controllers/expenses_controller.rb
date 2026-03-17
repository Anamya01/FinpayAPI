class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: [ :show, :update, :destroy ]

  def index
    # to resolv n+1 query issue
    expenses = if current_user.admin?
                 Expense.includes(:user, :category, receipts: { file_attachment: :blob })
    else
                 current_user.expenses.includes(:category, receipts: { file_attachment: :blob })
    end

    render json: ExpenseSerializer.new(expenses).serialize
  end

  def show
    render json: ExpenseSerializer.new(@expense).serialize
  end

  def create
    expense = current_user.expenses.new(expense_params)

    if expense.save
      render json: ExpenseSerializer.new(expense).serialize, status: :created
    else
      render json: { errors: expense.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @expense.update(expense_params)
      render json: ExpenseSerializer.new(@expense).serialize
    else
      render json: { errors: @expense.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    head :no_content
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
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
end
