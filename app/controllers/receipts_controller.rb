class ReceiptsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense

  def destroy
    receipt = @expense.receipts.find(params[:id])
    receipt.destroy

    head :no_content
  end

  private

  def set_expense
    @expense = Expense.find(params[:expense_id])
  end
end
