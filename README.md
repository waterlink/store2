# Store2

Persistence in YAML files, yay!

## Installation

Add this line to your application's Gemfile:

```ruby
gem "store2"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install store2

## Usage

```ruby
require "store2"
```

### Open a file

```ruby
store2 = Store2.open("test.yml")
# => <#Store2::File:0x00f28746a47 @filename = "test.yml">
```

### Get root-scoped store object

```ruby
root_scoped = store2.build
# => <#Store2::Scoped:0x00f2d746a41 @keys = []>
```

### Get scoped store object

```ruby
user_scoped = store2.scoped("users", "72AC97F03A")
# => <#Store2::Scoped:0x00a2d746a91 @keys = ["users", "72AC97F03A"]
```

### Get scoped store object out of another scoped store object

```ruby
items_scoped = user_scoped.scoped("items")
# => <#Store2::Scoped:0x00922faa907 @keys = ["users", "72AC97F03A", "items"]
```

### Reading the value

```ruby
user_scoped.get("profile", "email")
# => "john@example.org"
```

raises `KeyError` if value is not present

### Writing the value

```ruby
user_scoped.set("profile", "name", "John Smith")
# => "John Smith"
```

### Reading the value with writing the default if missing

```ruby
# when profile/email is present
user_scoped.get_or_set("profile", "email", "john.smith@example.org")
# => "john@example.org"

# when profile/alternative_email is not present
user_scoped.get_or_set("profile", "alternative_email", "john.smith@example.org")
# => "john.smith@example.org"
```

Does not raise `KeyError`

### Check if value is present

```ruby
user_scoped.has?("profile", "email")
# => true

user_scoped.has?("profile", "some", "long", "nested", "and", "boring", "attribute")
# => false
```

### Fetch value and provide block for execution if it is not present

```ruby
items_scoped.fetch(item_code) do
  fail ItemNotFound, "Item #{item_code} is not found"
end
```

### Saving your changes back to the file

```ruby
store.save

# the same as
root_scoped.save

# the same as
user_scoped.save

# and
items_scoped.save
```

All of them eventually will delegate to `store.save`

## Contributing

1. Fork it ( https://github.com/waterlink/store2/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
