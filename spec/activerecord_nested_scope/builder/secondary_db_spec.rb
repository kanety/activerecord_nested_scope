if Rails::VERSION::MAJOR >= 6
  describe ActiveRecordNestedScope::Builder do
    context 'secondary db' do
      it 'has_one' do
        expect(Secondary::Manager.in_group(1).length).to be > 0
      end
    
      it 'has_many' do
        expect(Secondary::Organization.in_group(1).length).to be > 0
      end
    
      it 'belongs_to' do
        expect(Secondary::User.in_group(1).length).to be > 0
        expect(Secondary::UserConfig.in_group(1).length).to be > 0
      end
    
      it 'polymorphic belongs_to' do
        expect(Secondary::Polymorphism.in_group(1).length).to be > 0
      end
    end
  end
end
