class SourceMap::Group < ActiveRecord::Base
  self.table_name = 'groups'
  nested_scope :in_group
end
