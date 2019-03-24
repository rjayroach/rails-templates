# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_policies, class_name: 'ActiveUserPolicy'
  has_many :policies, through: :user_policies
  has_many :actions, through: :policies

  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :group_actions, through: :groups, source: :actions

  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :role_actions, through: :roles, source: :actions

  def action_permitted?(action)
    return actions.exists?(id: action.id) || group_actions.exists?(id: action.id)
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
