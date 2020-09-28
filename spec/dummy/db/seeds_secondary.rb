1.upto(10) do |i|
  group = Group.find(i)

  organization = Secondary::Organization.create(title: "organization#{i}")
  group.update_columns(secondary_organization_id: organization.id)
  Secondary::Polymorphism.create(record: organization)

  manager = Secondary::Manager.create(title: "manager#{i}")
  group.update_columns(secondary_manager_id: manager.id)
  Secondary::Polymorphism.create(record: manager)

  user = Secondary::User.create(group: group, title: "user#{i}")
  Secondary::Polymorphism.create(record: user)

  user_config = Secondary::UserConfig.create(user: user, title: "user_cofig#{i}")
  Secondary::Polymorphism.create(record: user_config)
end
