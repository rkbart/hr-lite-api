class Attendance < ApplicationRecord
 belongs_to :user

  # Optional: auto-calculate total hours before save (if both clock_in and clock_out are present)
  before_save :calculate_total_hours, if: -> { clock_in.present? && clock_out.present? && total_hours.blank? }

  private

  def calculate_total_hours
    self.total_hours = ((clock_out - clock_in) / 1.hour).round(2)
  end
end
