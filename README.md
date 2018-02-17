# ActiveRecordNestedScope

An ActiveRecord extension to build nested scopes through pre-defined associations.

## Dependencies

* ruby 2.3+
* rails 5.0+ (activerecord and activesupport)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord_nested_scope'
```

Then execute:

    $ bundle

## Usage

For example, define `in_group` scope using nested_scope as follows:

```ruby
class Group < ActiveRecord::Base
  nested_scope :in_group  # root scope
  ...
end

class User < ActiveRecord::Base
  belongs_to :group
  nested_scope :in_group, through: :group  # User belongs to Group
  ...
end

class UserConfig < ActiveRecord::Base
  belongs_to :user
  nested_scope :in_group, through: :user  # UserConfig belongs to Group through User
  ...
end
```

`in_group` scope generates SQL as follows:

```ruby
User.in_group(id: 1)
#=> SELECT "users".* FROM "users" WHERE "users"."group_id" IN (SELECT "groups"."id" FROM "groups" WHERE "groups"."id" = 1)

UserConfig.in_group(id: 1)
#=> SELECT "user_configs".* FROM "user_configs" WHERE "user_configs"."user_id" IN (SELECT "users"."id" FROM "users" WHERE "users"."group_id" IN (SELECT "groups"."id" FROM "groups" WHERE "groups"."id" = 1))
```

### Polymorphic association

If you define a polymorphic association like that,

```ruby
class Name < ActiveRecord::Base
  belongs_to :data, polymorphic: true
  nested_scope :in_group, through: :data
end
```

`in_group` scope generates union of subqueries for each polymorpchic type:

```ruby
Name.in_group(id: 1)
#=> SELECT "names"."data_type" FROM "names" GROUP BY "names"."data_type"
#=> SELECT "names".* FROM ( SELECT "names".* FROM ( SELECT "names".* FROM ( SELECT "names".* FROM "names" WHERE "names"."data_type" = 'Group' AND "names"."data_id" IN (SELECT "groups"."id" FROM "groups" WHERE "groups"."id" = 1) UNION SELECT "names".* FROM "names" WHERE "names"."data_type" = 'Manager' AND "names"."data_id" IN (SELECT "managers"."id" FROM "managers" WHERE "managers"."id" IN (SELECT "groups"."manager_id" FROM "groups" WHERE "groups"."id" = 1)) ) "names" UNION SELECT "names".* FROM "names" WHERE "names"."data_type" = 'Supervisor' AND "names"."data_id" IN (SELECT "supervisors"."id" FROM "supervisors" WHERE "supervisors"."id" IN (SELECT "managers"."supervisor_id" FROM "managers" WHERE "managers"."id" IN (SELECT "groups"."manager_id" FROM "groups" WHERE "groups"."id" = 1))) ) "names" UNION SELECT "names".* FROM "names" WHERE "names"."data_type" = 'User' AND "names"."data_id" IN (SELECT "users"."id" FROM "users" WHERE "users"."group_id" IN (SELECT "groups"."id" FROM "groups" WHERE "groups"."id" = 1)) ) "names"
```

Note that the first SQL is executed to load `data_type`, and the second SQL is built using loaded `data_type` variations.

### Scope examples

```ruby
# pass a integer
User.in_group(1)

# pass a hash
User.in_group(id: 1)

# pass an AR relation
User.in_group(Group.where(id: 1))
```

## Contributing

Bug reports and pull requests are welcome at https://github.com/kanety/activerecord_nested_scope.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
