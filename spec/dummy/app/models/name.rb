class Name < ActiveRecord::Base
  belongs_to :data, polymorphic: true
  nested_scope :in_group, through: :data
  nested_scope :in_group_join, through: :data, join: true
end
