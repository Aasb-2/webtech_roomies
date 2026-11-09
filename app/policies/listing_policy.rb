class ListingPolicy < BasePolicy

  def index?
    true
  end

  def show?
    return true unless record.draft?
    user.present? && (moderator? || record.property.host_id == user.id)
  end

  def create?
    user.present? && (moderator? || record.property.host_id == user.id)
  end
  alias_method :new?, :create?

  def update?
    user.present? && (moderator? || record.property.host_id == user.id)
  end
  alias_method :edit?, :update?

  def destroy?
    update?
  end

  def publish?   = update?
  def withdraw?  = update?
  def mark_rented? = update?

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end