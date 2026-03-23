require 'rails_helper'

RSpec.describe CompanyProvisioningService, type: :service do
  let(:company) { create(:company, subdomain: 'newcorp') }
  let(:email) { 'admin@newcorp.com' }
  let(:password) { 'password123' }

  after do
    Apartment::Tenant.drop('newcorp') rescue nil
  end

  describe '.call' do
    it 'creates tenant and admin user' do
      described_class.call(company, email, password)

      expect(Apartment.tenant_names).to include('newcorp')

      within_tenant('newcorp') do
        admin = User.find_by(email: email)

        expect(admin).to be_present
        expect(admin.role).to eq('admin')
      end
    end
  end
end
