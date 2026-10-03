class User < ApplicationRecord
  ROLES = %w[member moderator].freeze

  has_many :properties, foreign_key: :host_id, inverse_of: :host, dependent: :destroy
  has_many :listings, through: :properties
  has_many :applications, foreign_key: :seeker_id, inverse_of: :seeker, dependent: :destroy
  has_many :reviews, foreign_key: :seeker_id, inverse_of: :seeker, dependent: :destroy
  has_many :saved_listings, dependent: :destroy
  has_many :saved_listing_listings, through: :saved_listings, source: :listing
  has_many :reports, foreign_key: :reporter_id, inverse_of: :reporter, dependent: :destroy

  before_validation { email&.downcase!&.strip! }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                     format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: ROLES }

  def moderator?
    role == "moderator"
  end

  def member?
    role == "member"
  end
end