# dev_mate
[![Build Status](https://travis-ci.org/DEGoodmanWilson/ruby-devmate.svg?branch=master)](https://travis-ci.org/DEGoodmanWilson/ruby-devmate)
[![Coverage Status](https://coveralls.io/repos/github/DEGoodmanWilson/ruby-devmate/badge.svg?branch=master)](https://coveralls.io/github/DEGoodmanWilson/ruby-devmate?branch=master)

You use [DevMate](http://devmate.com) for selling your OS X apps, and your back-end is written in Ruby. This is the gem for you :D

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dev_mate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dev_mate

## Usage

The DevMate API is centered on Customer objects. A customer represents, yes you guessed it, one of your customers. NB: No two customers may share the same email address.

To start working with the DevMate API, you'll need to (of course) create an account, and register your application. You will also need an API key, available from your [DevMate Dashboard](https://dashboard.devmate.com) under Company Settings > API Integration

### Setting your API Token
```ruby
DevMate::DevMate.SetToken('foobar')
```

### Creating a new customer object
```ruby
customer = DevMate::DevMate.CreateCustomer( { "email" => "foo@example.com", "first_name" => "Jon", "last_name" => "Snow" } )
```



### Updating an existing customer object
```ruby
customer["last_name"] = "Stark"
DevMate::DevMate.UpdateCustomer(customer)
```

### Finding a customer by Id
```ruby
customer = DevMate::DevMate.FindCustomerById(42)
```

### Searching for customers by email address or name
```ruby
customerListWithEmail = DevMate::DevMate.FindCustomerWithFilters(email: "foo@example.com")

customerListWithName = DevMate::DevMate.FindCustomerWithFilters(last_name: "Snow")
```

### Creating a license key for a customer

(You'll need to know the Id of the license type that you want to create)

```ruby
license = DevMate::DevMate.CreateLicense(customer, 1)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DEGoodmanWilson/dev_mate. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

