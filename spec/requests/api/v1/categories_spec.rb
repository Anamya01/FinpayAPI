require 'swagger_helper'

RSpec.describe 'Categories API', type: :request do
  path '/api/v1/categories' do
    get 'List categories' do
      tags 'Categories'
      produces 'application/json'
      security [ bearer_auth: [] ]

      response '200', 'admin success' do
        include_context 'admin authenticated'

        before { create_list(:category, 3) }
        run_test!
      end

      response '403', 'forbidden' do
        include_context 'authenticated'
        run_test!
      end
    end

    post 'Create category' do
      tags 'Categories'
      consumes 'application/json'
      security [ bearer_auth: [] ]

      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string }
        },
        required: [ 'name' ]
      }

      response '201', 'created' do
        include_context 'admin authenticated'

        let(:category) do
          {
            name: 'Food',
            description: 'Food expenses'
          }
        end

        run_test!
      end

      response '403', 'forbidden' do
        include_context 'authenticated'
        let(:category) { { name: 'Test' } }
        run_test!
      end
    end
  end

  path '/api/v1/categories/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Get category' do
      tags 'Categories'
      security [ bearer_auth: [] ]

      let(:category_record) { create(:category) }
      let(:id) { category_record.id }

      response '200', 'admin success' do
        include_context 'admin authenticated'
        run_test!
      end

      response '403', 'forbidden' do
        include_context 'authenticated'
        run_test!
      end
    end

    put 'Update category' do
      tags 'Categories'
      consumes 'application/json'
      security [ bearer_auth: [] ]

      let(:category_record) { create(:category) }
      let(:id) { category_record.id }

      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string }
        }
      }

      response '200', 'updated' do
        include_context 'admin authenticated'

        let(:category) { { name: 'Updated Name' } }
        run_test!
      end

      response '403', 'forbidden' do
        include_context 'authenticated'

        let(:category) { { name: 'Fail' } }
        run_test!
      end
    end

    delete 'Delete category' do
      tags 'Categories'
      security [ bearer_auth: [] ]

      let(:category_record) { create(:category) }
      let(:id) { category_record.id }

      response '204', 'deleted' do
        include_context 'admin authenticated'
        run_test!
      end

      response '403', 'forbidden' do
        include_context 'authenticated'
        run_test!
      end
    end
  end
end
