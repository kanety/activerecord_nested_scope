class SourceMap::Polymorphism < ActiveRecord::Base
  self.table_name = 'polymorphisms'
  belongs_to :record, polymorphic: true
  nested_scope :in_group, through: :record, source_map: ->(type) { "SourceMap::#{type}" }
end
