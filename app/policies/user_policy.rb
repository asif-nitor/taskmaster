class UserPolicy < ApplicationPolicy

  def index?
    admin?
  end

  def show?
    admin?
  end

  def destroy?
    admin?
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      else
        scope.none
      end
    end
  end

  private

  def admin?
    user&.admin?
  end
end