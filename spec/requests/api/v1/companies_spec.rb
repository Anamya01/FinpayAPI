require 'swagger_helper'

RSpec.describe 'Companies API', type: :request do
  let!(:existing_company) { create(:company) }

  path '/api/v1/companies' do
    get 'List companies' do
      tags 'Companies'
      produces 'application/json'

      response '200', 'successful' do
        run_test!
      end
    end

    post 'Create company' do
      tags 'Companies'
      consumes 'application/json'

      parameter name: :company_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          subdomain: { type: :string },
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[name subdomain email password]
      }

      let(:company_params) do
        {
          name: 'New Corp',
          subdomain: 'newcorp',
          email: 'admin@newcorp.com',
          password: 'password123'
        }
      end

      response '201', 'created' do
        after { Apartment::Tenant.drop('newcorp') rescue nil }
        run_test!
      end
    end
  end

  path '/api/v1/companies/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Show company' do
      tags 'Companies'

      let(:id) { existing_company.id }

      response '200', 'successful' do
        run_test!
      end
    end

    put 'Update company' do
      tags 'Companies'
      consumes 'application/json'

      parameter name: :update_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        }
      }

      let(:id) { existing_company.id }
      let(:update_params) { { name: 'Updated Company Name' } }

      response '200', 'updated' do
        run_test!
      end
    end

    delete 'Delete company' do
      tags 'Companies'

      let(:id) { existing_company.id }

      response '204', 'deleted' do
        run_test!
      end
    end
  end
end
