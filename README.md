# ActiveRecordNestedScope

An ActiveRecord extension to build nested scopes through pre-defined associations.

## Dependencies

* ruby 2.3+
* activerecord 5.0+
* activesupport 5.0+

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
#=> SELECT "users".* FROM "users" WHERE "users"."group_id" IN (
#     SELECT "groups"."id" FROM "groups" WHERE "groups"."id" = 1)

UserConfig.in_group(id: 1)
#=> SELECT "user_configs".* FROM "user_configs" WHERE "user_configs"."user_id" IN (
#     SELECT "users"."id" FROM "users" WHERE "users"."group_id" IN (
#       SELECT "groups"."id" FROM "groups" WHERE "groups"."id" = 1))
```

### Polymorphic association

If you define a polymorphic association,
`in_group` generates union of subqueries for each polymorpchic type as follows:

```ruby
class Polymorphism < ActiveRecord::Base
  belongs_to :record, polymorphic: true
  nested_scope :in_group, through: :record
end

Polymorphism.in_group(id: 1)
#=> SELECT "polymorphisms"."record_type" FROM "polymorphisms" GROUP BY "polymorphisms"."record_type"
#=> SELECT "polymorphisms".* FROM (
#     SELECT "polymorphisms".* FROM "polymorphisms" WHERE "polymorphisms"."record_type" = 'Group' AND "polymorphisms"."record_id" IN (SELECT "groups"."id" FROM "groups" WHERE "groups"."id" = 1) UNION
#     SELECT "polymorphisms".* FROM "polymorphisms" WHERE "polymorphisms"."record_type" = 'User' AND "polymorphisms"."record_id" IN (SELECT "users"."id" FROM "users" WHERE "users"."group_id" IN (SELECT "groups"."id" FROM "groups" WHERE "groups"."id" = 1)) UNION
#     SELECT "polymorphisms".* FROM "polymorphisms" WHERE "polymorphisms"."record_type" = 'UserConfig' AND "polymorphisms"."record_id" IN (SELECT "user_configs"."id" FROM "user_configs" WHERE "user_configs"."user_id" IN (SELECT "users"."id" FROM "users" WHERE "users"."group_id" IN (SELECT "groups"."id" FROM "groups" WHERE "groups"."id" = 1)))
#   ) AS polymorphisms
```

Note that the first SQL is executed to load `record_type`,
and the second SQL is built using loaded `record_type` variations.

### Scope arguments

```ruby
# pass a integer
User.in_group(1)

# pass an array
User.in_group([1, 2, 3])

# pass a hash
User.in_group(id: 1)

# pass an AR relation
User.in_group(Group.where(id: 1))
```

### Multiple database

If you define a nested_scope among models stored into different databases,
SQL is separated into multiple queries for each database and they are merged by using IN clause.
For example:

```ruby
class Secondary::Base < ActiveRecord::Base
  self.abstract_class = true
  connects_to database: { writing: :secondary, reading: :secondary }
end

# users are stored into secondary database
class Secondary::User < Secondary:::Base
  belongs_to :group, class_name: 'Group'
  nested_scope :in_group, through: :group
  ...
end

# user_configs are also stored into secondary database
class Secondary::UserConfig < Secondary::Base
  belongs_to :user
  nested_scope :in_group, through: :user
  ...
end

Secondary::User.in_group(id: 1)
#=> SELECT "groups"."id" FROM "groups" WHERE "groups"."id" = 1
#=> SELECT "users".* FROM "users" WHERE "users"."group_id" IN (1, 2, 3)

Secondary::UserConfig.in_group(id: 1)
#=> SELECT "groups"."id" FROM "groups" WHERE "groups"."id" = 1
#=> SELECT "user_configs".* FROM "user_configs" WHERE "user_configs"."user_id" IN (
#     SELECT "users"."id" FROM "users" WHERE "users"."group_id" IN (1, 2, 3) 
```

## Contributing

Bug reports and pull requests are welcome at https://github.com/kanety/activerecord_nested_scope.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
