require 'swagger_helper'

RSpec.describe 'Auth Sessions API', type: :request do
  path '/api/v1/login' do
    post 'User login' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            },
            required: %w[email password]
          }
        },
        required: [ 'user' ]
      }

      let!(:user_record) { create(:user, password: 'password123') }

      let(:user) do
        {
          user: {
            email: user_record.email,
            password: 'password123'
          }
        }
      end

      response '201', 'login successful' do
        run_test! do |response|
          expect(response.headers['Authorization']).to be_present
        end
      end

      response '401', 'invalid credentials' do
        let(:user) do
          {
            user: {
              email: 'wrong@test.com',
              password: 'wrong'
            }
          }
        end

        run_test!
      end
    end
  end

  path '/api/v1/logout' do
    delete 'User logout' do
      tags 'Auth'
      security [ bearer_auth: [] ]

      include_context 'authenticated'

      response '204', 'logout successful' do
        run_test!
      end
    end
  end
end
