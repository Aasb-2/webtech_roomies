class ReviewPolicy < BasePolicy
  def create?
    user.present? &&
      !moderator? &&
      record.seeker_id == user.id &&
      user.id != record.property.host_id &&
      completed_visit_exists?
  end
  alias_method :new?, :create?

  def destroy?
    user.present? && (moderator? || record.seeker_id == user.id)
  end

  private

  def completed_visit_exists?
    Visit.joins(application: :listing)
         .where(status: "completed")
         .where(applications: { seeker_id: user.id })
         .where(listings: { property_id: record.property_id })
         .exists?
  end

  class Scope < Scope
    def resolve
      scope.all # reviews are shown publicly on property pages
    end
  end
end