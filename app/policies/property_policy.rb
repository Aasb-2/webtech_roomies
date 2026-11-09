class PropertyPolicy < BasePolicy

  def index?
    user.present?
  end

  def show?
    true # property pages stay public, per the assignment brief
  end

  def create?
    user.present?
  end
  alias_method :new?, :create?

  def update?
    user.present? && (moderator? || record.host_id == user.id)
  end
  alias_method :edit?, :update?

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end