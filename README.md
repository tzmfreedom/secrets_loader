# SecretsLoader

Secret value loader from Secrets Manager on Ruby on Rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'secrets_loader'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install secrets_loader

## Usage

SecretsLoader load secret values from secrets manager automatically.  
You should set environment variable ENABLE_SECRETS_LOADER to '1' and  
SECRETS_MANAGER_SECRET_ID to your secrets manager's secret-id.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tzmfreedom/secrets_loader.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
