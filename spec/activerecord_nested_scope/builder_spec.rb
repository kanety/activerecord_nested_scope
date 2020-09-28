describe ActiveRecordNestedScope::Builder do
  it 'has_one' do
    expect(Manager.in_group(1).length).to be > 0
  end

  it 'has_many' do
    expect(Organization.in_group(1).length).to be > 0
    expect(Supervisor.in_group(1).length).to be > 0
  end

  it 'belongs_to' do
    expect(User.in_group(1).length).to be > 0
    expect(UserConfig.in_group(1).length).to be > 0
  end

  it 'polymorphic belongs_to' do
    expect(Polymorphism.in_group(1).length).to be > 0
  end

  it 'polymorphic belongs_to for empty table' do
    expect(EmptyPolymorphism.in_group(1).length).to be 0
  end

  [1, "1", [1], { id: 1 }, Group.find(1), Group.where(id: 1)].each do |g|
    it "takes #{g.class} argument" do
      expect(User.in_group(g).length).to be > 0
    end
  end

  it "takes nil argument" do
    expect(User.in_group(nil).length).to be 0
  end
end
