class Availability < ApplicationRecord
  belongs_to :park_spot
  validates_presence_of :date, :start_time, :end_time
  validate :validate_time_interval

  def validate_time_interval
    if start_time + 1.hour >= end_time
      errors.add(:end_time, "End time should be at least 1 hour before start time.")
    end
  end
end
