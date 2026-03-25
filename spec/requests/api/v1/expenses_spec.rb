require 'swagger_helper'

RSpec.describe 'Expenses API', type: :request do
  path '/api/v1/expenses' do
    get 'List expenses' do
      tags 'Expenses'
      produces 'application/json'
      security [ bearer_auth: [] ]

      include_context 'authenticated'

      parameter name: :category_id, in: :query, schema: { type: :integer }, required: false
      parameter name: :start_date, in: :query, schema: { type: :string }, required: false
      parameter name: :end_date, in: :query, schema: { type: :string }, required: false
      parameter name: :status, in: :query, schema: { type: :string }, required: false

      response '200', 'member sees own expenses' do
        before { create_list(:expense, 3, user: current_user) }
        run_test!
      end

      response '200', 'admin sees all expenses' do
        include_context 'admin authenticated'

        before { create_list(:expense, 3) }
        run_test!
      end
    end

    post 'Create expense' do
      tags 'Expenses'
      consumes 'application/json'
      produces 'application/json'
      security [ bearer_auth: [] ]

      include_context 'authenticated'

      parameter name: :expense, in: :body, schema: EXPENSE_SCHEMA

      let(:category) { create(:category) }

      let(:expense) do
        {
          expense: {
            name: 'Lunch',
            amount: 20.5,
            description: 'Team lunch',
            date: '2024-01-01',
            category_id: category.id
          }
        }
      end

      response '201', 'created' do
        run_test!
      end
    end
  end

  path '/api/v1/expenses/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Get expense' do
      tags 'Expenses'
      produces 'application/json'
      security [ bearer_auth: [] ]

      let(:expense_record) { create(:expense, user: current_user) }
      let(:id) { expense_record.id }

      response '200', 'owner access' do
        include_context 'authenticated'
        run_test!
      end

      response '200', 'admin access' do
        include_context 'admin authenticated'
        let(:expense_record) { create(:expense) }
        run_test!
      end
    end

    put 'Update expense' do
      tags 'Expenses'
      consumes 'application/json'
      security [ bearer_auth: [] ]

      include_context 'authenticated'

      let(:expense_record) { create(:expense, user: current_user) }
      let(:id) { expense_record.id }

      parameter name: :expense, in: :body, schema: {
        type: :object,
        properties: {
          expense: {
            type: :object,
            properties: {
              name: { type: :string },
              amount: { type: :number },
              description: { type: :string }
            }
          }
        }
      }

      let(:expense) do
        { expense: { name: 'Updated Expense' } }
      end

      response '200', 'updated' do
        run_test!
      end
    end

    delete 'Delete expense' do
      tags 'Expenses'
      security [ bearer_auth: [] ]

      include_context 'authenticated'

      let(:expense_record) { create(:expense, user: current_user) }
      let(:id) { expense_record.id }

      response '204', 'deleted' do
        run_test!
      end
    end
  end

  %w[approve reject reimburse].each do |action|
    path "/api/v1/expenses/{id}/#{action}" do
      post "#{action} expense" do
        tags 'Expenses'
        security [ bearer_auth: [] ]

        parameter name: :id, in: :path, type: :integer

        let(:expense_record) { create(:expense) }
        let(:id) { expense_record.id }

        response '200', 'admin success' do
          include_context 'admin authenticated'

          before do
            allow_any_instance_of(ExpenseWorkflowService)
              .to receive(action.to_sym)
              .and_return({ status: :ok, message: 'success' })
          end

          run_test!
        end

        it_behaves_like 'forbidden'
      end
    end
  end
end
