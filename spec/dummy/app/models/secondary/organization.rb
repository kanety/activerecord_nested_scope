class Secondary::Organization < Secondary::Base
  has_many :groups, class_name: 'Group', foreign_key: :secondary_organization_id
  nested_scope :in_group, through: :groups
end
