require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  subject { build(:expense, user: user, category: category) }

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:category) }

    # Custom association for Approver
    it { should belong_to(:approver).class_name('User').with_foreign_key(:approved_by_id).optional }
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:amount) }

    it { should validate_numericality_of(:amount).is_greater_than(0) }

    it { should validate_length_of(:description).is_at_most(1200) }
  end

  describe "Factory" do
    it "has a valid factory" do
      expect(build(:expense, user: user, category: category)).to be_valid
    end
  end
end
