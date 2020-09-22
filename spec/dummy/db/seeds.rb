10.times do |i|
  supervisor = Supervisor.create(title: "supervisor#{i}")
  Polymorphism.create(record: supervisor)

  manager = Manager.create(supervisor: supervisor, title: "manager#{i}")
  Polymorphism.create(record: manager)

  group = Group.create(manager: manager, title: "group#{i}")
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
