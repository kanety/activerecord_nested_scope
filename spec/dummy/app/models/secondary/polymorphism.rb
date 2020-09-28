class Secondary::Polymorphism < Secondary::Base
  belongs_to :record, polymorphic: true
  nested_scope :in_group, through: :record
end
