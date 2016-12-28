[![Gem Version](https://badge.fury.io/rb/pluck_all.svg)](http://badge.fury.io/rb/pluck_all)
[![Code Climate](https://codeclimate.com/github/khiav223577/pluck_all/badges/gpa.svg)](https://codeclimate.com/github/khiav223577/pluck_all)
[![Test Coverage](https://codeclimate.com/github/khiav223577/pluck_all/badges/coverage.svg)](https://codeclimate.com/github/khiav223577/pluck_all/coverage)
[![Build Status](https://travis-ci.org/khiav223577/pluck_all.svg?branch=master)](https://travis-ci.org/khiav223577/pluck_all)

# PluckAll

Pluck multiple attributes in Rails 3. Also support in Rails 4, and Rails 5

This Gem standing on the shoulders of this [article](http://meltingice.net/2013/06/11/pluck-multiple-columns-rails/).
And modify it to support not only Rail 3.

If you have a Rails 3 project, and want to pluck not only one column, 
feel free to use this gem and no need to worry about upgrading to Rails 4, 5 in the future will break this.



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pluck_all'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pluck_all

## Usage
### pluck to array
Behaves the same as the Rails 4 pluck, but you can use it in Rails 3
```rb
User.where(:id => [1,2]).pluck_array(:id, :account)
# => [[1, 'account1'], [2, 'account2']]
```
### pluck to hash
Similar to `pluck_array`, but return hash instead.
```rb
User.where(:id => [1,2]).pluck_all(:id, :account)
# => [{"id"=>1, "account"=>"account1"}, {"id"=>2, "account"=>"account2"}] 
User.where(:id => [1,2]).pluck_all('id, account AS name')
# => [{"id"=>1, "name"=>"account1"}, {"id"=>2, "name"=>"account2"}] 
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/khiav223577/pluck_all. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

