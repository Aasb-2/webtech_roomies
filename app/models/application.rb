class Application < ApplicationRecord
  STATES = %w[pending shortlisted accepted rejected withdrawn].freeze
  ANSWERABLE_STATES = %w[pending shortlisted].freeze

  belongs_to :listing
  belongs_to :seeker, class_name: "User", foreign_key: :seeker_id, inverse_of: :applications

  has_one :visit, dependent: :destroy

  validates :move_in_date, presence: true
  validates :duration_months, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :state, presence: true, inclusion: { in: STATES }
  validates :seeker_id, uniqueness: { scope: :listing_id, message: "can only apply once to the same listing" }

  validate :seeker_is_not_the_host
  validate :listing_is_published, on: :create
  validate :only_one_accepted_per_listing, if: -> { state == "accepted" }

  def pending?
    state == "pending"
  end

  def shortlisted?
    state == "shortlisted"
  end

  def accepted?
    state == "accepted"
  end

  def rejected?
    state == "rejected"
  end

  def withdrawn?
    state == "withdrawn"
  end

  def shortlist!
    return false unless pending?
    update!(state: "shortlisted")
  end

  def reject!
    return false unless ANSWERABLE_STATES.include?(state)
    update!(state: "rejected")
  end

  def withdraw!
    return false unless ANSWERABLE_STATES.include?(state)
    update!(state: "withdrawn")
  end

  # Accepting is three effects that must happen together: this application
  # becomes accepted, every other pending/shortlisted application on the
  # same listing is rejected, and the listing moves to reserved. Wrapped in
  # a transaction so a failure anywhere rolls all of it back.
  def accept!
    return false unless ANSWERABLE_STATES.include?(state)

    transaction do
      update!(state: "accepted")
      listing.applications.where.not(id: id).where(state: ANSWERABLE_STATES)
             .update_all(state: "rejected", updated_at: Time.current)
      listing.reserve!
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def seeker_is_not_the_host
    return if listing.nil? || seeker.nil?

    errors.add(:seeker, "cannot apply to their own listing") if listing.property.host_id == seeker_id
  end

  def listing_is_published
    return if listing.nil?

    errors.add(:listing, "must be published to receive applications") unless listing.published?
  end

  def only_one_accepted_per_listing
    return if listing.nil?

    already_accepted = listing.applications.where(state: "accepted").where.not(id: id).exists?
    errors.add(:base, "this listing already has an accepted application") if already_accepted
  end
end