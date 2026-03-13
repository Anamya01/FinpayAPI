require "rails_helper"

RSpec.describe "Authentication", type: :request do
  describe "POST /register" do
    it "creates a new user" do
      expect {
        post "/register", params: {
          email: "user@test.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "POST /login" do
    let!(:user) { create(:user, email: "login@test.com", password: "password123") }
    it "logs in successfully and returns JWT" do
      post "/login", params: {
        email: "login@test.com",
        password: "password123"
      }

      expect(response).to have_http_status(:ok)
      expect(response.headers["Authorization"]).to be_present
    end
  end

  describe "POST /login with invalid credentials" do
    it "returns unauthorized" do
      post "/login", params: {
        email: "wrong@test.com",
        password: "wrongpassword"
      }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
