class SavedListingPolicy < BasePolicy
  def index?
    user.present?
  end

  def create?
    user.present? && record.user_id == user.id
  end

  def destroy?
    user.present? && record.user_id == user.id
  end

  class Scope < Scope
    def resolve
      user ? scope.where(user_id: user.id) : scope.none
    end
  end
end