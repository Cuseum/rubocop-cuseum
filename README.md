# RuboCop Cuseum

Custom RuboCop cops for enforcing Cuseum service class conventions.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubocop-cuseum', github: 'cuseum/rubocop-cuseum'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rubocop-cuseum

## Usage

Put this into your `.rubocop.yml`:

```yaml
require:
  - rubocop-cuseum
```

## Cops

### Cuseum/SinglePublicMethodService

Ensures that service classes have at most one public method.

```ruby
# good - zero public methods
class UserService < BaseService
  private

  def process_user
    # ...
  end
end

# good - one public method
class UserService < BaseService
  def call
    # ...
  end

  private

  def process_user
    # ...
  end
end

# bad - multiple public methods
class UserService < BaseService
  def call
    # ...
  end

  def execute  # ← should be private
    # ...
  end
end
```

### Cuseum/InheritFromBaseService

Ensures that service classes inherit from BaseService directly or indirectly.

```ruby
# good - direct inheritance
class UserService < BaseService
  def call
    # ...
  end
end

# good - indirect inheritance through ApplicationService
class UserService < ApplicationService
  def call
    # ...
  end
end

# bad - no inheritance from BaseService
class UserService
  def call
    # ...
  end
end
```

### Cuseum/PublicMethodNamedCall

Ensures that any public method in service classes is named "call".

```ruby
# good - public method named "call"
class UserService < BaseService
  def call
    # ...
  end

  private

  def process_user
    # ...
  end
end

# bad - public method with wrong name
class UserService < BaseService
  def execute  # ← should be "call"
    # ...
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cuseum/rubocop-cuseum.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
