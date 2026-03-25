require 'rails_helper'

RSpec.describe AuditLogJob, type: :job do
  let(:user) { create(:user) }
  let(:expense) { create(:expense, user: user) }
  let(:tenant) { 'test' }

  around do |example|
    Sidekiq::Testing.inline! { example.run }
  end

  it 'creates an ActivityLog record in the correct tenant' do
    expect {
      AuditLogJob.perform_async(tenant, expense.id, user.id, 'approved')
    }.to change {
      within_tenant(tenant) { ActivityLog.count }
    }.by(1)
  end
end
