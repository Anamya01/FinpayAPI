require 'rails_helper'

RSpec.describe Receipt, type: :model do
  let(:expense) { create(:expense) }
  subject { Receipt.new(expense: expense) }

  describe "Associations" do
    it { should belong_to(:expense) }
  end

  describe "Attachments" do
    it { should have_one_attached(:file) }
  end
end
