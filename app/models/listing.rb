class Listing < ApplicationRecord
  STATES = %w[draft published reserved rented withdrawn].freeze
  MAX_PHOTO_SIZE = 5.megabytes
  ALLOWED_PHOTO_TYPES = %w[image/jpeg image/png image/webp]

  belongs_to :property

  has_many :applications, dependent: :destroy
  has_many :saved_listings, dependent: :destroy
  has_many :savers, through: :saved_listings, source: :user
  has_many :reports, dependent: :destroy

  has_many_attached :photos
  has_rich_text :description
  has_rich_text :house_rules

  validates :monthly_rent, presence: true, numericality: { greater_than: 0 }
  validates :deposit, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :available_date, presence: true
  validates :minimum_stay, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :state, presence: true, inclusion: { in: STATES }
  validate :photos_are_valid

  scope :published, -> { where(state: "published") }
  scope :in_neighborhood, ->(neighborhood_id) { joins(:property).where(properties: { neighborhood_id: neighborhood_id }) if neighborhood_id.present? }
  scope :max_rent, ->(amount) { where(monthly_rent: ..amount) if amount.present? }
  scope :available_from, ->(date) { where(available_date: ..date) if date.present? }
  scope :with_amenity, ->(amenity_id) { joins(property: :amenities).where(amenities: { id: amenity_id }) if amenity_id.present? }

  def draft?
    state == "draft"
  end

  def published?
    state == "published"
  end

  def reserved?
    state == "reserved"
  end

  def rented?
    state == "rented"
  end

  def withdrawn?
    state == "withdrawn"
  end

  def cover_photo
    photos.first
  end

  # These lifecycle methods return false (instead of raising) when the
  # transition isn't allowed from the current state, so controllers can show
  # a flash message instead of crashing.

  def publish!
    return false unless draft?
    update!(state: "published")
  end

  def reserve!
    update!(state: "reserved")
  end

  def withdraw!
    return false if rented?
    transaction do
      update!(state: "withdrawn")
      applications.where(state: %w[pending shortlisted]).update_all(state: "withdrawn", updated_at: Time.current)
    end
    true
  end

  def mark_rented!
    return false unless reserved?
    update!(state: "rented")
  end

  private

  def photos_are_valid
    return unless photos.attached?

    photos.each do |photo|
      if photo.blob.byte_size > MAX_PHOTO_SIZE
        errors.add(:photos, "#{photo.filename} is larger than 5MB")
      end

      unless photo.blob.content_type.in?(ALLOWED_PHOTO_TYPES)
        errors.add(:photos, "#{photo.filename} must be a JPEG, PNG, or WebP image")
      end
    end
  end
end