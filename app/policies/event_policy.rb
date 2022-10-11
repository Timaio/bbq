class EventPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def create?
    user.present?
  end

  def show?
    true
  end

  def update?
    user_owns?
  end

  def destroy?
    user_owns?
  end

  def index?
    true
  end

  private

  def user_owns?
    user.present? && (record.user == user)
  end
end
