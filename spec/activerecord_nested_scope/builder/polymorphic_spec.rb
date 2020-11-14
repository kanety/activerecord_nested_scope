describe ActiveRecordNestedScope::Builder do
  context 'with polymorphic' do
    it 'belongs_to' do
      expect(Polymorphism.in_group(1).length).to be > 0
    end

    it 'belongs_to for empty table' do
      expect(Polymorphism::Empty.in_group(1).length).to be 0
    end

    it 'resolves source types using source_map option' do
      expect(SourceMap::Polymorphism.in_group(1).map { |p| [p.record_type, p.record_id] }).to eq([['Group', 1]])
    end
  end
end
