class CustomKey::HasOne < ActiveRecord::Base
  self.table_name = :custom_key_has_ones
  has_one :group, class_name: 'Group', primary_key: :created_at, foreign_key: :created_at
  nested_scope :in_group, through: :group
end
