require "rails_helper"

RSpec.describe "Authentication", type: :request do
  # Use a helper for headers to ensure JSON is always used
  let(:headers) { { "Accept" => "application/json" } }

  describe "POST /signup" do
    it "creates a new user" do
      # DEBUG: Check where we are before the post
      # puts "RSpec is looking in tenant: #{Apartment::Tenant.current}"

      post "/signup", params: {
        email: "user_#{Time.now.to_i}@test.com", # Unique email
        password: "password123",
        password_confirmation: "password123"
      }, headers: headers

      # If it fails, this will show us the real error (Validation? 404? 500?)
      if response.status != 201
        puts "FAILED RESPONSE: #{response.status} - #{response.body}"
      end

      expect(response).to have_http_status(:created)

      # Explicitly check the count inside the specific schema
      count = Apartment::Tenant.switch('test') { User.count }
      expect(count).to eq(1)
    end
  end

  describe "POST /login" do
    # Create the user directly in the 'test' schema
    let!(:user) {
      Apartment::Tenant.switch('test') do
        User.create!(email: "login@test.com", password: "password123", role: :member)
      end
    }

    it "logs in successfully" do
      post "/login", params: { user: {
        email: "login@test.com",
        password: "password123"
      } }, headers: headers

      if response.status != 200
        puts "LOGIN FAILED: #{response.status} - #{response.body}"
      end

      expect(response).to have_http_status(:created)
    end
  end
end
