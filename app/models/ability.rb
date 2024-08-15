# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role?(:chief_editor)
      can :manage, :all
    elsif user.has_role?(:editor)
      can :read, :all
      can :create, Article
      can :update, Article, user_id: user.id
      can :update, User, id: user.id
    elsif user.has_role?(:viewer)
      can :read, :all
      can :update, User, id: user.id
    else
      can :read, :all
    end
  end
end