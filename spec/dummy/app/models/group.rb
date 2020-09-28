class Group < ActiveRecord::Base
  belongs_to :organization
  belongs_to :manager

  belongs_to :secondary_organization, class_name: 'Secondary::Organization'
  belongs_to :secondary_manager, class_name: 'Secondary::Manager'

  nested_scope :in_group
  nested_scope :in_invalid, through: :invalid
end
