class User < ActiveRecord::Base
  belongs_to :group
  nested_scope :in_group, through: :group
  nested_scope :in_group_join, through: :group, join: true
end
