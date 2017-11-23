class Group < ActiveRecord::Base
  belongs_to :manager
  nested_scope :in_group
  nested_scope :in_group_join, join: true

  nested_scope :in_invalid, through: :invalid
  nested_scope :in_invalid_join, through: :invalid, join: true
end
