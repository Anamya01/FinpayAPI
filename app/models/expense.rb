class Expense < ApplicationRecord
  include AASM
  belongs_to :user
  belongs_to :category
  has_many :receipts, dependent: :destroy
  accepts_nested_attributes_for :receipts, allow_destroy: true
  belongs_to :approver,
             class_name: "User",
             foreign_key: :approved_by_id,
             optional: true
  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :description, length: { maximum: 1200 }
  # AASM
  aasm column: :status do
    state :pending, initial: true
    state :approved
    state :rejected
    state :reimbursed
    state :archived

    event :approve do
      transitions from: :pending, to: :approved
    end
    event :reject do
      transitions from: :pending, to: :rejected
    end
    event :reimburse do
      transitions from: :approved, to: :reimbursed
    end
    event :archived do
      transitions from: [ :approved, :rejected, :reimbursed ], to: :archived
    end
  end
end
