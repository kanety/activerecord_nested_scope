class Supervisor < ActiveRecord::Base
  has_many :managers
  nested_scope :in_group, through: :managers
  nested_scope :in_group_join, through: :managers, join: true
end
