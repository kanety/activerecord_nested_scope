class Manager < ActiveRecord::Base
  belongs_to :supervisor
  has_one :group
  nested_scope :in_group, through: :group
  nested_scope :in_group_join, through: :group, join: true
end
