class Policy < ApplicationRecord
  has_many :user_policies
  has_many :users, through: :user_policies
  has_many :policy_actions
  has_many :actions, through: :policy_actions
end
