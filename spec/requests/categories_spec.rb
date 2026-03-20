require 'rails_helper'

RSpec.describe "Categories", type: :request do
  # Ensure admin and category are created in the correct schema
  let!(:admin) { create(:user, role: :admin) }
  let!(:member) { create(:user, role: :member) }
  let!(:category) { create(:category) }
  let(:headers) { authenticated_header(admin) }
  let(:member_headers) { authenticated_header(member) }

  describe "POST /categories" do
    let(:valid_params) { { category: { name: "Office Supplies", description: "Paper and Pens" } } }

    it "creates a category within the 'test' tenant" do
      post "/categories", params: valid_params, headers: headers

      expect(response).to have_http_status(:created)

      # Verify the data exists in the specific tenant schema
      Apartment::Tenant.switch!('test') do
        expect(Category.count).to eq(2)
        expect(Category.last.name).to eq("Office Supplies")
      end
    end

    it "denies access to non-admin users" do
      post "/categories", params: valid_params, headers: member_headers
      expect(response).to have_http_status(:forbidden)
      expect(JSON.parse(response.body)['error']).to eq("Not authorized")
    end
  end

  describe "GET /categories/:id" do
    it "returns the specific category" do
      get "/categories/#{category.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(category.name)
    end
  end

  describe "PATCH /categories/:id" do
    it "updates the category name" do
      patch "/categories/#{category.id}",
            params: { category: { name: "New Name" } },
            headers: headers

      expect(response).to have_http_status(:ok)

      Apartment::Tenant.switch!('test') do
        expect(category.reload.name).to eq("New Name")
      end
    end
  end
end
