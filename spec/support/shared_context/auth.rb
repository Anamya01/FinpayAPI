RSpec.shared_context 'authenticated' do
  let(:current_user) { create(:user, role: :member) }
  let(:Authorization) { authenticated_header(current_user)['Authorization'] }
end

RSpec.shared_context 'admin authenticated' do
  let(:current_user) { create(:user, role: :admin) }
  let(:Authorization) { authenticated_header(current_user)['Authorization'] }
end
