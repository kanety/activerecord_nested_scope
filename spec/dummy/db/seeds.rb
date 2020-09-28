1.upto(10) do |i|
  supervisor = Supervisor.create(title: "supervisor#{i}")
  Polymorphism.create(record: supervisor)

  manager = Manager.create(supervisor: supervisor, title: "manager#{i}")
  Polymorphism.create(record: manager)

  organization = Organization.create(title: "organization#{i}")
  Polymorphism.create(record: organization)

  group = Group.create(organization: organization, manager: manager, title: "group#{i}")
  Polymorphism.create(record: group)

  user = User.create(group: group, title: "user#{i}")
  Polymorphism.create(record: user)

  user_config = UserConfig.create(user: user, title: "user_cofig#{i}")
  Polymorphism.create(record: user_config)

  polymorphism_isolation = Polymorphism::Isolation.create(title: "polymorphism_isolation#{i}")
  Polymorphism.create(record: polymorphism_isolation)

  custom_key_has_many = CustomKey::HasMany.create(title: "custom_key_has_many#{i}", created_at: group.created_at, updated_at: group.updated_at)
  custom_key_has_one = CustomKey::HasOne.create(title: "custom_key_has_one#{i}", created_at: group.created_at, updated_at: group.updated_at)
  custom_key_belongs_to = CustomKey::BelongsTo.create(title: "custom_key_belongs_to#{i}", created_at: group.created_at, updated_at: group.updated_at)
end

Polymorphism.create(record_id: 0, record_type: 'INVALID_TYPE')
Polymorphism.create(record_id: nil, record_type: nil)
