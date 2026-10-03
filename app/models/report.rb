class Report < ApplicationRecord
  REASONS = %w[fraudulent misleading offensive other].freeze
  STATUSES = %w[pending reviewed dismissed].freeze

  belongs_to :reporter, class_name: "User", foreign_key: :reporter_id, inverse_of: :reports
  belongs_to :listing

  validates :reason, presence: true, inclusion: { in: REASONS }
  validates :status, presence: true, inclusion: { in: STATUSES }
end