class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:

    user ||= User.new # guest user (not logged in)
    if user.admin_role?
      can :manage, :all
    end
    if user.supervisor_role?
      can :manage, User
      can :manage, Organization
      can :manage, Employee
    end

  end
end
