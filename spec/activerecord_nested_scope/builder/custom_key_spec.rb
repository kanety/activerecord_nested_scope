describe ActiveRecordNestedScope::Builder do
  context 'with custom key' do
    it 'has_many' do
      expect(CustomKey::HasMany.in_group(id: 1).length).to be > 0
    end

    it 'has_one' do
      expect(CustomKey::HasOne.in_group(id: 1).length).to be > 0
    end

    it 'belongs_to' do
      expect(CustomKey::BelongsTo.in_group(id: 1).length).to be > 0
    end
  end
end
