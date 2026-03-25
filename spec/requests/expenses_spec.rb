require 'rails_helper'

RSpec.describe "Expenses", type: :request do
  let!(:user) { create(:user) }
  let!(:category) { create(:category) }
  let(:headers) { authenticated_header(user) }

  describe "POST /api/v1/expenses" do
    it "creates an expense" do
      params = {
        expense: {
          name: "Business Trip",
          amount: 100.0,
          category_id: category.id,
          date: Date.today
        }
      }

      post "/api/v1/expenses", params: params, headers: headers

      expect(response).to have_http_status(:created), response.body

      within_tenant do
        expect(Expense.last.name).to eq("Business Trip")
      end

      within_tenant do
        expect(Expense.count).to eq(1)
        expect(Expense.last.user_id).to eq(user.id)
      end
    end
  end
end
