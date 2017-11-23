10.times do
  supervisor = Supervisor.create(test: "test")
  manager = Manager.create(supervisor: supervisor)
  group = Group.create(manager: manager)
  user = User.create(group: group)
  UserConfig.create(user: user)
  Name.create(data: supervisor)
  Name.create(data: manager)
  Name.create(data: group)
  Name.create(data: user)
end
