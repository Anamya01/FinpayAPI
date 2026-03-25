require 'rails_helper'

RSpec.describe ReceiptProcessorJob, type: :job do
  let(:tenant) { 'test' }

  let(:expense) do
    within_tenant(tenant) { create(:expense, :with_receipts) }
  end

  before do
    Apartment::Tenant.create(tenant) rescue nil
  end

  around do |example|
    Sidekiq::Testing.inline! { example.run }
  end

  describe '#perform' do
    context 'when expense exists' do
      it 'processes all receipts and logs filenames' do
        within_tenant(tenant) do
          expense
        end

        # Spy on logger
        allow(Rails.logger).to receive(:info)

        ReceiptProcessorJob.perform_async(tenant, expense.id)

        within_tenant(tenant) do
          expense.receipts.each do |receipt|
            expect(Rails.logger).to have_received(:info)
              .with("Processing #{receipt.filename}")
          end
        end
      end
    end

    context 'when expense does not exist' do
      it 'does not raise error' do
        expect {
          ReceiptProcessorJob.perform_async(tenant, -1)
        }.not_to raise_error
      end

      it 'does not log anything' do
        allow(Rails.logger).to receive(:info)

        ReceiptProcessorJob.perform_async(tenant, -1)

        expect(Rails.logger).not_to have_received(:info)
      end
    end

    context 'when expense has no receipts' do
      let(:expense) do
        within_tenant(tenant) { create(:expense) }
      end

      it 'does not log anything' do
        allow(Rails.logger).to receive(:info)

        ReceiptProcessorJob.perform_async(tenant, expense.id)

        expect(Rails.logger).not_to have_received(:info)
      end
    end
  end
end
