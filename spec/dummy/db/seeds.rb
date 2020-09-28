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

  isolation = Isolation.create(title: "isolation#{i}")
  Polymorphism.create(record: isolation)
end

Polymorphism.create(record_id: 0, record_type: 'INVALID_TYPE')
Polymorphism.create(record_id: nil, record_type: nil)
