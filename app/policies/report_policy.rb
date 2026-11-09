class ReportPolicy < BasePolicy
  def create?
    user.present?
  end
  alias_method :new?, :create?

  def index?
    moderator?
  end

  def update?
    moderator?
  end

  class Scope < Scope
    def resolve
      user&.moderator? ? scope.all : scope.none
    end
  end
end