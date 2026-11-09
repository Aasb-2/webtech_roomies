class VisitPolicy < BasePolicy
  def create?
    user.present? && !moderator? &&
      (record.application.seeker_id == user.id || record.application.listing.property.host_id == user.id)
  end
  alias_method :new?, :create?

  def update?
    create?
  end

  class Scope < Scope
    def resolve
      if user&.moderator?
        scope.all
      elsif user
        visible_application_ids = ApplicationPolicy::Scope.new(user, Application).resolve.select(:id)
        scope.where(application_id: visible_application_ids)
      else
        scope.none
      end
    end
  end
end