class Review < ApplicationRecord
  belongs_to :property
  belongs_to :seeker, class_name: "User", foreign_key: :seeker_id, inverse_of: :reviews

  validates :rating, presence: true, inclusion: { in: 1..5 }
  # Simplification for this stage: one review per seeker per property.
  # Tighten to "once per completed visit" once reviews link to visits and
  # write actions exist (Assignment 3).
  validates :seeker_id, uniqueness: { scope: :property_id, message: "has already reviewed this property" }

  validate :seeker_is_not_the_host

  private

  def seeker_is_not_the_host
    return if property.nil? || seeker.nil?

    errors.add(:seeker, "cannot review their own property") if property.host_id == seeker_id
  end
end