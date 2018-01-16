# Todoable
[![Build Status](https://travis-ci.org/dtom90/todoable.svg?branch=master)](https://travis-ci.org/dtom90/todoable)

A Ruby gem that wraps the endpoints of a todo list service HTTP API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'todoable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install todoable

## Usage

```ruby
service = Todoable::Service.new(ENV['username'], ENV['password'])

@service.create_list 'New List'
p @service.get_lists
p @service.get_list '<list_id>'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/dtom90/todoable](https://github.com/dtom90/todoable).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
