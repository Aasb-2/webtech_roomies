class ApplicationPolicy < BasePolicy
  def show?
    user.present? && (moderator? || record.seeker_id == user.id || record.listing.property.host_id == user.id)
  end

  def create?
    user.present? &&
      record.listing.property.host_id != user.id &&
      !record.listing.draft?
  end
  alias_method :new?, :create?

  def update?
    user.present? && !moderator? && record.listing.property.host_id == user.id
  end

  def destroy?
    user.present? && record.seeker_id == user.id
  end

  class Scope < Scope
    def resolve
      if user&.moderator?
        scope.all
      elsif user
        scope.where(seeker_id: user.id)
             .or(scope.where(listing_id: Listing.joins(:property).where(properties: { host_id: user.id }).select(:id)))
      else
        scope.none
      end
    end
  end
end