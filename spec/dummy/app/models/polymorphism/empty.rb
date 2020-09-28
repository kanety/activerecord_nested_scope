class Polymorphism::Empty < ActiveRecord::Base
  self.table_name = :polymorphism_empties
  belongs_to :record, polymorphic: true
  nested_scope :in_group, through: :record
end
