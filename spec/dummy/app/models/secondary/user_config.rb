class Secondary::UserConfig < Secondary::Base
  belongs_to :user
  nested_scope :in_group, through: :user
end
