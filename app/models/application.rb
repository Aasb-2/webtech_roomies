class Application < ApplicationRecord
  STATES = %w[pending shortlisted accepted rejected withdrawn].freeze

  belongs_to :listing
  belongs_to :seeker, class_name: "User", foreign_key: :seeker_id, inverse_of: :applications

  has_one :visit, dependent: :destroy

  validates :move_in_date, presence: true
  validates :duration_months, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :state, presence: true, inclusion: { in: STATES }
  validates :seeker_id, uniqueness: { scope: :listing_id, message: "can only apply once to the same listing" }

  validate :seeker_is_not_the_host
  validate :listing_is_published, on: :create

  private

  def seeker_is_not_the_host
    return if listing.nil? || seeker.nil?

    errors.add(:seeker, "cannot apply to their own listing") if listing.property.host_id == seeker_id
  end

  def listing_is_published
    return if listing.nil?

    errors.add(:listing, "must be published to receive applications") unless listing.published?
  end
end