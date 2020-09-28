class Secondary::Manager < Secondary::Base
  has_one :group, class_name: 'Group', foreign_key: :secondary_manager_id
  nested_scope :in_group, through: :group
end
