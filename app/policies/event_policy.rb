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
    return true if record.pincode.blank? || user.user == record.user

    if user.pincode.present? && record.pincode_correct?(user.pincode)
      user.cookies["event_#{record.id}_pincode"] = user.pincode
    end

    cookies_pincode = user.cookies["event_#{record.id}_pincode"]
    record.pincode_correct?(cookies_pincode)
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
    user.present? && (record.user == user.user)
  end
end
