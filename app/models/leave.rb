class Leave < ApplicationRecord
  belongs_to :user

  enum leave_type: { vacation_leave: "vacation leave", sick_leave: "sick leave" }
  enum status: { pending: "pending", approved: "approved", rejected: "rejected" }

  validates :start_date, :end_date, :leave_type, :reason, presence: true
  validates :end_date, comparison: { greater_than_or_equal_to: :start_date }
end
