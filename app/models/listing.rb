class Listing < ApplicationRecord
  STATES = %w[draft published reserved rented withdrawn].freeze

  belongs_to :property

  has_many :applications, dependent: :destroy
  has_many :saved_listings, dependent: :destroy
  has_many :savers, through: :saved_listings, source: :user
  has_many :reports, dependent: :destroy

  validates :monthly_rent, presence: true, numericality: { greater_than: 0 }
  validates :deposit, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :available_date, presence: true
  validates :minimum_stay, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :state, presence: true, inclusion: { in: STATES }

  scope :published, -> { where(state: "published") }
  scope :in_neighborhood, ->(neighborhood) { joins(:property).where(properties: { neighborhood: neighborhood }) if neighborhood.present? }
  scope :max_rent, ->(amount) { where(monthly_rent: ..amount) if amount.present? }
  scope :available_from, ->(date) { where(available_date: ..date) if date.present? }
  scope :with_amenity, ->(amenity) { joins(:property).where("properties.amenities @> ARRAY[?]::varchar[]", amenity) if amenity.present? }

  def draft?
    state == "draft"
  end

  def published?
    state == "published"
  end
end