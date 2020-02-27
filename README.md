# Blackbird::Retoure

Blackbird::Retoure is a Ruby implementation of the DHL Retoure REST API.
The documentation of the API itself is located at: https://entwickler.dhl.de/group/ep/wsapis/retouren

Currently Blackbird::Retoure does support version 1.0 of the API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blackbird-retoure'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blackbird-retoure

## Usage

### Configuration

Before you can call the DHL Retoure API you need to set up your account according to https://entwickler.dhl.de/group/ep/wsapis/retouren/authentifizierung

Add an initializer to your application and configure the gem as follows:

```ruby
Blackbird::Retoure.configure do |config|
  config.username = 'USERNAME'
  config.password = 'PASSWORD'
end
```
#### Sandbox
For `USERNAME` use your developer id of your developer account and for `PASSWORD` the matching password of your developer account.

#### Production
For `USERNAME` use your AppId and for the `PASSWORD` use the one time token.

#### Optional configuration options

TBD

## Development

After checking out the repo, run `bin/setup` to install dependencies.

As the DHL API need a personal username and password for the Sandbox environment, duplicate the YAML file `spec/support/dev_environments/default.yml` and name it like your login user and change the default values in it. All files added to this directory will be ignored by commits.

Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/blackbird-retoure. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Blackbird::Retoure project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/blackbird-retoure/blob/master/CODE_OF_CONDUCT.md).
