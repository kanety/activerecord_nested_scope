class Secondary::User < Secondary::Base
  belongs_to :group, class_name: 'Group'
  nested_scope :in_group, through: :group
end
