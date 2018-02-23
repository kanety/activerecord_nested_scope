class Supervisor < ActiveRecord::Base
  has_many :managers, -> { order(:id) }
  nested_scope :in_group, through: :managers
end
