class Supervisor < ActiveRecord::Base
  has_many :managers
  nested_scope :in_group, through: :managers
end
