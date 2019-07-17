# SimpleEnum::Multiple

SimpleEnum::Multiple is extension of SimpleEnum, which brings multi-select
enum support to [SimpleEnum](https://github.com/lwe/simple_enum).

## ActiveRecord Quick start

Add this to a model:
```ruby
class User < ActiveRecord::Base
  as_enum :favorites, [:iphone, :ipad, :macbook], {
    accessor: :bitwise
  }
end
```

Then you can add a `bitwise` column

```ruby
add_column :Users, :favorite_cds,
  :integer
```

It will store multi-enums data in a integer column, and if you don't want
SimpleEnum::Multiple manage how you store your data, you can use `multiple`
accessor:

```ruby
as_enum :favorites, [:iphone, :ipad, :macbook], {
  accessor: :multiple
}
```

This accessor will not handle how the data saved in the database,
so you have to use something like `serialize :favorite_cds`, or implement
your own encoder.

## Working with multi-select enums

```ruby
class User < ActiveRecord::Base
  as_enum :favorites, [
    :iphone, :ipad, :macbook
  ]
end

jane = User.new
jane.favorites = [:iphone, :ipad]
jane.favorites # => [:iphone, ipad]
jane.favorite_cds # => [0, 1]
jane.macbook? # => false
jane.iphone? # => true
jane.ipad? # => true

joe = User.new
joe.iphone! # => [:iphone]
joe.favorites # => [:iphone]
joe.favorite_cds # => [0]

User.favorites # => #<SimpleEnum::Enum:0x0....>
User.iphones # => #<ActiveRecord::Relation:0x0.... [jane, joe]>
User.favorites.values_at(:iphone, :ipad) # => [0, 1]
User.favorites[:iphone] # => [0]

# You can also do this since `favorites` returns a
# #<SimpleEnum::Multiple::Proxy> rather than a #<Array>:
joe = User.new
joe.iphone! # => [:iphone]
joe.favorites # => [:iphone, ipad]
joe.favorite_cds # => [0, 1]
joe.favorites.push :ipad
```

## License

The gem is available as open source under the terms
of the [MIT License](http://opensource.org/licenses/MIT).
