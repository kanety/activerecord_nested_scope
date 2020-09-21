describe ActiveRecordNestedScope::Node do
  class NodeTest < ActiveRecord::Base
    has_many :children, class_name: name
    belongs_to :parent, class_name: name
    belongs_to :polymorphic, polymorphic: true

    nested_scope :in_parent, through: :parent
    nested_scope :in_children, through: :children
    nested_scope :in_polymorphic, through: :polymorphic

    nested_scope :invalid, through: :invalid
  end

  it 'recognizes has_many' do
    node = ActiveRecordNestedScope::Node.new(NodeTest, :in_children)
    expect(node.has_many?).to eq(true)
    expect(node.reflection).not_to eq(nil)
  end

  it 'recognizes belongs_to' do
    node = ActiveRecordNestedScope::Node.new(NodeTest, :in_parent)
    expect(node.belongs_to?).to eq(true)
    expect(node.reflection).not_to eq(nil)
  end

  it 'recognizes polymorphic belongs_to' do
    node = ActiveRecordNestedScope::Node.new(NodeTest, :in_polymorphic)
    expect(node.polymorphic_belongs_to?).to eq(true)
    expect(node.reflection).not_to eq(nil)
  end

  it 'returns false for undefined association' do
    node = ActiveRecordNestedScope::Node.new(NodeTest, :undefined)
    expect(node.valid?).to eq(false)
  end

  it 'returns false for invalid association' do
    node = ActiveRecordNestedScope::Node.new(NodeTest, :invalid)
    expect(node.valid?).to eq(false)
  end
end
