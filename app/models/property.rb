class Property < ApplicationRecord
  PROPERTY_TYPES = %w[apartment house studio townhouse].freeze

  belongs_to :host, class_name: "User", foreign_key: :host_id, inverse_of: :properties

  has_many :listings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :address, presence: true
  validates :neighborhood, presence: true
  validates :property_type, presence: true, inclusion: { in: PROPERTY_TYPES }
  validates :bedrooms, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :bathrooms, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def average_rating
    reviews.average(:rating)&.round(1)
  end
end