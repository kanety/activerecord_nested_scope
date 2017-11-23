class UserConfig < ActiveRecord::Base
  belongs_to :user
  nested_scope :in_group, through: :user
  nested_scope :in_group_join, through: :user, join: true
end
