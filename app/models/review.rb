class Review < ApplicationRecord
  belongs_to :property
  belongs_to :seeker, class_name: "User", foreign_key: :seeker_id, inverse_of: :reviews

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :seeker_id, uniqueness: { scope: :property_id, message: "has already reviewed this property" }

  validate :seeker_is_not_the_host
  validate :seeker_has_a_completed_visit, on: :create

  private

  def seeker_is_not_the_host
    return if property.nil? || seeker.nil?

    errors.add(:seeker, "cannot review their own property") if property.host_id == seeker_id
  end

  def seeker_has_a_completed_visit
    return if property.nil? || seeker.nil?

    completed_visit_exists = Visit.joins(application: :listing)
                                   .where(status: "completed")
                                   .where(applications: { seeker_id: seeker_id })
                                   .where(listings: { property_id: property_id })
                                   .exists?

    errors.add(:base, "you can only review a property after a completed visit there") unless completed_visit_exists
  end
end