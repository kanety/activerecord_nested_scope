class Organization < ActiveRecord::Base
  has_many :groups
  nested_scope :in_group, through: :groups
end
