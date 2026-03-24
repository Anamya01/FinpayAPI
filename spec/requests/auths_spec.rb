require "rails_helper"

RSpec.describe "Authentication", type: :request do
  let(:headers) do
    {
      "Accept" => "application/json",
      "X-Company-Id" => @company.id.to_s
    }
  end

  describe "POST /api/v1/signup" do
    let(:user_attributes) { attributes_for(:user) }

    it "creates a user" do
      post "/api/v1/signup", params: { user: user_attributes }, headers: headers

      expect(response).to have_http_status(:created), response.body

      within_tenant do
        expect(User.exists?(email: user_attributes[:email])).to be true
      end
    end
  end

  describe "POST api/v1/login" do
    let(:password) { "password123" }

    let!(:user) do
      within_tenant do
        create(:user, password: password)
      end
    end

    it "logs in successfully" do
      post "/api/v1/login",
           params: { user: { email: user.email, password: password } },
           headers: headers

      expect(response).to have_http_status(:created), response.body
    end
  end
end
