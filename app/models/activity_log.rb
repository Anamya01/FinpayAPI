class ActivityLog < ApplicationRecord
  belongs_to :expense
  belongs_to :user
  validates :action, presence: true
end
