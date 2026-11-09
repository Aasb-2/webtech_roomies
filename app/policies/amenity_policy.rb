class AmenityPolicy < BasePolicy
  def index?   = moderator?
  def show?    = moderator?
  def create?  = moderator?
  def new?     = create?
  def update?  = moderator?
  def edit?    = update?
  def destroy? = moderator?

  class Scope < Scope
    def resolve
      user&.moderator? ? scope.all : scope.none
    end
  end
end