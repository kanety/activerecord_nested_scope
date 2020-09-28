class CustomKey::BelongsTo < ActiveRecord::Base
  self.table_name = :custom_key_belongs_tos
  belongs_to :group, class_name: 'Group', primary_key: :updated_at, foreign_key: :updated_at
  nested_scope :in_group, through: :group
end
