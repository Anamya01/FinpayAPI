require 'rails_helper'
RSpec.describe ActivityLog, type: :model do
  describe 'associations' do
    it { should belong_to(:expense) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:action) }
  end
end
