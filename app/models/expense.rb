class Expense < ApplicationRecord
  include AASM
  belongs_to :user
  belongs_to :category
  has_many_attached :receipts
  has_many :activity_logs, dependent: :destroy
  belongs_to :approver,
             class_name: "User",
             foreign_key: :reviewed_by_id,
             optional: true
  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :description, length: { maximum: 1200 }

  # Scopes
  scope :by_category, ->(category_id) {
  category_id.present? ? where(category_id: category_id) : all
}

scope :by_status, ->(status) {
  status.present? ? where(status: status) : all
}

scope :in_date_range, ->(start_date, end_date) {
  (start_date.present? && end_date.present?) ? where(date: start_date..end_date) : all
}


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
    event :archive do
      transitions from: [ :approved, :rejected, :reimbursed ], to: :archived
    end
  end
end
