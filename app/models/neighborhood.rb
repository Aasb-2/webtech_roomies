class Neighborhood < ApplicationRecord
  has_many :properties, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end