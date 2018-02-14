class User < ActiveRecord::Base
  belongs_to :group
  nested_scope :in_group, through: :group
end
