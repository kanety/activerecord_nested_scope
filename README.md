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
  nested_scope :in_group
  ...
end

class User < ActiveRecord::Base
  belongs_to :group
  nested_scope :in_group, through: :group
  ...
end

class UserConfig < ActiveRecord::Base
  belongs_to :user
  nested_scope :in_group, through: :user
  ...
end
```

`in_group` scope generates SQL as follows:

```ruby
User.in_group(id: 1)
 #=> SELECT  "users".* FROM "users" WHERE "users"."group_id" IN (SELECT "groups"."id" FROM "groups" WHERE "groups"."id" = 1)

UserConfig.in_group(id: 1)
 #=> SELECT  "user_configs".* FROM "user_configs" WHERE "user_configs"."user_id" IN (SELECT "users"."id" FROM "users" WHERE "users"."group_id" IN (SELECT "groups"."id" FROM "groups" WHERE "groups"."id" = 1))
```

## Contributing

Bug reports and pull requests are welcome at https://github.com/kanety/activerecord_nested_scope.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
