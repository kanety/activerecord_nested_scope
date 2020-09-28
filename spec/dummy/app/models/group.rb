class Group < ActiveRecord::Base
  belongs_to :organization
  belongs_to :manager
  nested_scope :in_group
  nested_scope :in_invalid, through: :invalid
end
