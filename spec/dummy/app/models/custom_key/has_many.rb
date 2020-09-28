class CustomKey::HasMany < ActiveRecord::Base
  self.table_name = :custom_key_has_manies
  has_many :groups, class_name: 'Group', primary_key: :created_at, foreign_key: :created_at
  nested_scope :in_group, through: :groups
end
