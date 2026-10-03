class Visit < ApplicationRecord
  STATUSES = %w[scheduled confirmed cancelled completed].freeze

  belongs_to :application

  validates :proposed_date, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }

  def completed?
    status == "completed"
  end
end