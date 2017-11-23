describe ActiveRecordNestedScope do
  it 'has a version number' do
    expect(ActiveRecordNestedScope::VERSION).not_to be nil
  end

  let(:id) { 1 }
  let(:hash) { { id: 1 } }
  let(:ar) { Group.find(1) }
  let(:ar_relation) { Group.where(id: 1) }
  let(:valid_patterns) { [nil, id, hash, ar, ar_relation] }

  context 'build subquery' do
    it 'belongs_to' do
      valid_patterns.each do |g|
        expect(User.in_group(g).count).to be > 0
        expect(UserConfig.in_group(g).count).to be > 0
      end
    end

    it 'belongs_to with polymorphic' do
      valid_patterns.each do |g|
        expect(Name.in_group(g).count).to be > 0
      end
    end

    it 'has_one' do
      valid_patterns.each do |g|
        expect(Manager.in_group(g).count).to be > 0
      end
    end

    it 'has_many' do
      valid_patterns.each do |g|
        expect(Supervisor.in_group(g).count).to be > 0
      end
    end
  end

  context 'build join query' do
    it 'belongs_to' do
      valid_patterns.each do |g|
        expect(User.in_group_join(g).count).to be > 0
        expect(UserConfig.in_group_join(g).count).to be > 0
      end
    end

    it 'has_one' do
      valid_patterns.each do |g|
        expect(Manager.in_group_join(g).count).to be > 0
      end
    end

    it 'has_many' do
      valid_patterns.each do |g|
        expect(Supervisor.in_group_join(g).count).to be > 0
      end
    end
  end

  context 'invalid arguments' do
    it 'invalid join for polymorphic association' do
      expect { Name.in_group_join(1) }.to raise_error(ArgumentError)
    end

    it 'invalid association name' do
      expect { Group.in_invalid(1) }.to raise_error(ArgumentError)
      expect { Group.in_invalid_join(1) }.to raise_error(ArgumentError)
    end
  end
end
