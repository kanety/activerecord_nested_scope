class UserConfig < ActiveRecord::Base
  belongs_to :user
  nested_scope :in_group, through: :user
end
