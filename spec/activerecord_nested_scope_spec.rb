describe ActiveRecordNestedScope do
  it 'has a version number' do
    expect(ActiveRecordNestedScope::VERSION).not_to be nil
  end

  it 'belongs_to' do
    puts User.in_group(1).to_sql
    puts UserConfig.in_group(1).to_sql
    expect(User.in_group(1).count).to be > 0
    expect(UserConfig.in_group(1).count).to be > 0
  end

  it 'belongs_to with polymorphic' do
    puts Name.in_group(1).to_sql
    expect(Name.in_group(1).count).to be > 0
  end

  it 'has_one' do
    puts Manager.in_group(1).to_sql
    expect(Manager.in_group(1).count).to be > 0
  end

  it 'has_many' do
    puts Supervisor.in_group(1).to_sql
    expect(Supervisor.in_group(1).count).to be > 0
  end

  it 'takes several arguments' do
    [nil, 1, [1], { id: 1 }, Group.find(1), Group.where(id: 1)].each do |g|
      puts User.in_group(g).to_sql
      expect(User.in_group(g).count).to be > 0
    end
  end

  it 'raise errors for invalid association name' do
    expect { Group.in_invalid(1) }.to raise_error(ArgumentError)
  end

  context 'active_record_union' do
    it 'uses active_record_union' do
      require 'active_record_union'
      puts Name.in_group(1).to_sql
      expect(Name.in_group(1).count).to be > 0
    end
  end
end
