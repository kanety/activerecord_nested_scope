class UserConfig < ActiveRecord::Base
  belongs_to :user, -> { order(:id) }
  nested_scope :in_group, through: :user
end
