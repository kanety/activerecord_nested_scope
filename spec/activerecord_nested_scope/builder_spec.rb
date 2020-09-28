describe ActiveRecordNestedScope::Builder do
  it 'has_one' do
    puts Manager.in_group(1).to_sql
    expect(Manager.in_group(1).count).to be > 0
  end

  it 'has_many' do
    puts Organization.in_group(1).to_sql
    puts Supervisor.in_group(1).to_sql
    expect(Organization.in_group(1).count).to be > 0
    expect(Supervisor.in_group(1).count).to be > 0
  end

  it 'belongs_to' do
    puts User.in_group(1).to_sql
    puts UserConfig.in_group(1).to_sql
    expect(User.in_group(1).count).to be > 0
    expect(UserConfig.in_group(1).count).to be > 0
  end

  it 'polymorphic belongs_to' do
    puts Polymorphism.in_group(1).to_sql
    expect(Polymorphism.in_group(1).count).to be > 0
  end

  it 'polymorphic belongs_to for empty table' do
    puts EmptyPolymorphism.in_group(1).to_sql
    expect(EmptyPolymorphism.in_group(1).count).to be 0
  end

  [1, "1", [1], { id: 1 }, Group.find(1), Group.where(id: 1)].each do |g|
    it "takes #{g.class} argument" do
      puts User.in_group(g).to_sql
      expect(User.in_group(g).count).to be > 0
    end
  end

  it "takes nil argument" do
    puts User.in_group(nil).to_sql
    expect(User.in_group(nil).count).to be 0
  end
end
