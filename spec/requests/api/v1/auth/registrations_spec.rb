require 'swagger_helper'

RSpec.describe 'Auth Registrations API', type: :request do
  path '/api/v1/signup' do
    post 'Register user' do
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
              password: { type: :string },
              password_confirmation: { type: :string }
            },
            required: %w[email password password_confirmation]
          }
        },
        required: [ 'user' ]
      }

      let(:user) do
        {
          user: {
            email: 'test@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }
      end

      response '201', 'user created' do
        run_test!
      end
    end
  end

  path '/api/v1/user_info' do
    get 'Get current user' do
      tags 'Auth'
      produces 'application/json'
      security [ bearer_auth: [] ]

      include_context 'authenticated'

      response '200', 'user fetched' do
        run_test!
      end
    end
  end

  path '/api/v1/update_user' do
    put 'Update user' do
      tags 'Auth'
      consumes 'application/json'
      security [ bearer_auth: [] ]

      include_context 'authenticated'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string },
              current_password: { type: :string }
            },
            required: [ 'current_password' ]
          }
        },
        required: [ 'user' ]
      }

      let(:current_user) { create(:user, password: 'password123') }

      let(:user) do
        {
          user: {
            email: 'updated@example.com',
            current_password: 'password123'
          }
        }
      end

      response '200', 'user updated' do
        run_test!
      end
    end
  end

  path '/api/v1/delete_user' do
    delete 'Delete user' do
      tags 'Auth'
      security [ bearer_auth: [] ]

      include_context 'authenticated'

      response '200', 'user deleted' do
        run_test!
      end
    end
  end
end
