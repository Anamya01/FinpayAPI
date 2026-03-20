require 'rails_helper'

RSpec.describe "Expenses", type: :request do
  let!(:user) { create(:user) }
  let!(:category) { create(:category) }
  let(:headers) { authenticated_header(user) }

  describe "POST /expenses" do
    it "creates an expense within the 'test' tenant" do
      params = {
        expense: {
          name: "Business Trip",
          amount: 100.0,
          category_id: category.id,
          date: Date.today,
          receipts_attributes: [
            { file: fixture_file_upload('spec/fixtures/files/test.jpg', 'image/jpeg') }
          ]
        }
      }

      post "/expenses", params: params, headers: headers

      expect(response).to have_http_status(:created)

      # Verify the data exists in the 'test' schema
      Apartment::Tenant.switch!('test') do
        expect(Expense.count).to eq(1)
        expect(Expense.last.user_id).to eq(user.id)
      end
    end
  end
end
