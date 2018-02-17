describe ActiveRecordNestedScope do
  let(:int) { 1 }
  let(:hash) { { id: 1 } }
  let(:ar) { Group.find(1) }
  let(:ar_relation) { Group.where(id: 1) }
  let(:arguments) { [nil, int, hash, ar, ar_relation] }

  it 'has a version number' do
    expect(ActiveRecordNestedScope::VERSION).not_to be nil
  end

  it 'belongs_to' do
    arguments.each do |g|
      expect(User.in_group(g).count).to be > 0
      expect(UserConfig.in_group(g).count).to be > 0
    end
  end

  it 'belongs_to with polymorphic' do
    arguments.each do |g|
      expect(Name.in_group(g).count).to be > 0
    end
  end

  it 'has_one' do
    arguments.each do |g|
      expect(Manager.in_group(g).count).to be > 0
    end
  end

  it 'has_many' do
    arguments.each do |g|
      expect(Supervisor.in_group(g).count).to be > 0
    end
  end

  context 'invalid arguments' do
    it 'invalid association name' do
      expect { Group.in_invalid(1) }.to raise_error(ArgumentError)
    end
  end
end
