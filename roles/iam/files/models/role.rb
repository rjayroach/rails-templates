# frozen_string_literal: true

class Role < ApplicationRecord
  has_many :role_policies, class_name: 'ActiveRolePolicy'
  has_many :policies, through: :role_policies
  has_many :actions, through: :policies

  has_many :user_roles
  has_many :users, through: :user_roles
  has_many :user_actions, through: :users, source: :actions
end
