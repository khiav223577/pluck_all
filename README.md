# PluckAll

[![Gem Version](https://img.shields.io/gem/v/pluck_all.svg?style=flat)](http://rubygems.org/gems/pluck_all)
[![Build Status](https://travis-ci.org/khiav223577/pluck_all.svg?branch=master)](https://travis-ci.org/khiav223577/pluck_all)
[![RubyGems](http://img.shields.io/gem/dt/pluck_all.svg?style=flat)](http://rubygems.org/gems/pluck_all)
[![Code Climate](https://codeclimate.com/github/khiav223577/pluck_all/badges/gpa.svg)](https://codeclimate.com/github/khiav223577/pluck_all)
[![Test Coverage](https://codeclimate.com/github/khiav223577/pluck_all/badges/coverage.svg)](https://codeclimate.com/github/khiav223577/pluck_all/coverage)

Pluck multiple columns/attributes in Rails 3, 4, 5, and can return data as hash instead of only array.

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
User.where('id < 3').pluck_array(:id, :account)
# => [[1, 'account1'], [2, 'account2']]
```
### pluck to hash
Similar to `pluck_array`, but return hash instead.
```rb
User.where('id < 3').pluck_all(:id, :account)
# => [{"id"=>1, "account"=>"account1"}, {"id"=>2, "account"=>"account2"}] 

User.where('id < 3').pluck_all('id, account AS name')
# => [{"id"=>1, "name"=>"account1"}, {"id"=>2, "name"=>"account2"}] 
```

## Benchmark
### Compare with `map` and `as_json`

`pluck_all` return raw hash data without loading a bunch of records, in that having better performace than using `map` and `as_json`.

```
                                       user     system      total        real
map                               36.110000  61.200000  97.310000 ( 99.535375)
select + map                      10.530000   0.660000  11.190000 ( 12.550974)
as_json                           49.040000   1.120000  50.160000 ( 55.417534)
pluck_all                          3.310000   0.100000   3.410000 (  3.527775)
```
[test script](https://github.com/khiav223577/pluck_all/issues/18)

## Other Support
### Support Pluck Carrierwave Uploader (if you use carrierwave)
```rb
User.where(xxx).pluck_all(:profile_pic).map{|s| s['profile_pic'] }
```
is the same as
```rb
User.where(xxx).map(&:profile_pic)
```
If the uploader use something like: `model.id`, `model.name`
You should send these columns manually:
```rb
User.where(xxx).cast_need_columns(%i(id, name)).pluck_all(:id, :name, :profile_pic).map{|s| s['profile_pic'] }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/khiav223577/pluck_all. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

