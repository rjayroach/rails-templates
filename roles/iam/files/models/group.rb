# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :group_policies, class_name: 'ActiveGroupPolicy'
  has_many :policies, through: :group_policies
  has_many :actions, through: :policies

  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :user_actions, through: :users, source: :actions
end
