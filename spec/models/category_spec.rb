require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { create(:category) }

  describe "Associations" do
    it { should have_many(:expenses) }
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:description).is_at_most(500) }
  end
end
