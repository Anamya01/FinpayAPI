require 'rails_helper'

RSpec.describe ExpenseWorkflowService, type: :service do
  let(:user) { create(:user) }
  let(:expense) { create(:expense, status: initial_status) }
  let(:service) { described_class.new(expense, user) }

  before do
    Apartment::Tenant.switch!('test')
  end

  describe '#approve' do
    subject(:approve!) { service.approve }

    context 'when approvable' do
      let(:initial_status) { 'pending' }

      it 'updates status' do
        expect { approve! }
          .to change { expense.reload.status }
          .from('pending').to('approved')
      end

      it 'sets reviewed_by_id' do
        approve!
        expect(expense.reload.reviewed_by_id).to eq(user.id)
      end

      it 'enqueues audit log job with correct args' do
        expect { approve! }
          .to change(AuditLogJob.jobs, :size).by(1)

        expect(AuditLogJob.jobs.last['args'].first(4))
          .to eq([ 'test', expense.id, user.id, 'approved' ])
      end

      it 'returns success response' do
        result = approve!

        expect(result).to include(
          status: :ok,
          message: I18n.t('services.expense_workflow.success.approved')
        )
      end
    end

    context 'when not approvable' do
      let(:initial_status) { 'rejected' }

      it 'does not change status' do
        expect { approve! }
          .not_to change { expense.reload.status }
      end

      it 'returns error' do
        result = approve!

        expect(result).to include(
          status: :unprocessable_entity,
          message: I18n.t('services.expense_workflow.errors.cannot_approve')
        )
      end

      it 'does not enqueue job' do
        expect { approve! }
          .not_to change(AuditLogJob.jobs, :size)
      end
    end
  end

  describe '#archive' do
    subject(:archive!) { service.archive }

    context 'when pending' do
      let(:initial_status) { 'pending' }

      it 'enqueues audit log job' do
        expect { archive! }
          .to change(AuditLogJob.jobs, :size).by(1)

        expect(AuditLogJob.jobs.last['args'].first(4))
          .to eq([ 'test', expense.id, user.id, 'deleted' ])
      end
    end
  end
end
