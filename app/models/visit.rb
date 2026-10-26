class Visit < ApplicationRecord
  STATUSES = %w[scheduled confirmed cancelled completed].freeze

  belongs_to :application

  validates :proposed_date, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validate :application_must_be_shortlisted, on: :create
    validate :proposed_date_cannot_be_in_the_past, if: -> { status == "scheduled" && will_save_change_to_proposed_date? }

  def completed?
    status == "completed"
  end

  def cancelled?
    status == "cancelled"
  end

  def confirm!
    return false if cancelled? || completed?
    update!(status: "confirmed")
  end

  def cancel!
    return false if completed?
    update!(status: "cancelled")
  end

  def complete!
    return false if cancelled?
    update!(status: "completed")
  end

  def reschedule!(new_date)
    return false if completed? || cancelled?
    update!(proposed_date: new_date, status: "scheduled")
  end

  private

  def application_must_be_shortlisted
    errors.add(:application, "must be shortlisted before a visit can be proposed") if application && !application.shortlisted?
  end

  def proposed_date_cannot_be_in_the_past
    errors.add(:proposed_date, "can't be in the past") if proposed_date.present? && proposed_date < Time.current
  end
end