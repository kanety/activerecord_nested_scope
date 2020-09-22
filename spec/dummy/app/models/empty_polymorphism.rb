class EmptyPolymorphism < ActiveRecord::Base
  belongs_to :record, polymorphic: true
  nested_scope :in_group, through: :record
end
