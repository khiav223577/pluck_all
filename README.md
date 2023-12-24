# PluckAll

[![Gem Version](https://img.shields.io/gem/v/pluck_all.svg?style=flat)](http://rubygems.org/gems/pluck_all)
[![Build Status](https://github.com/khiav223577/pluck_all/workflows/Ruby/badge.svg)](https://github.com/khiav223577/pluck_all/actions)
[![RubyGems](http://img.shields.io/gem/dt/pluck_all.svg?style=flat)](http://rubygems.org/gems/pluck_all)
[![Code Climate](https://codeclimate.com/github/khiav223577/pluck_all/badges/gpa.svg)](https://codeclimate.com/github/khiav223577/pluck_all)
[![Test Coverage](https://codeclimate.com/github/khiav223577/pluck_all/badges/coverage.svg)](https://codeclimate.com/github/khiav223577/pluck_all/coverage)

Pluck multiple columns/attributes in Rails 3, 4, 5, 6, and can return data as hash instead of only array. Also supports `Mongoid`.

This Gem stands on the shoulders of this article: [Plucking Multiple Columns in Rails 3](https://meltingice.dev/2013/06/11/pluck-multiple-columns-rails/).
And modified to support not only Rail 3.

If you have a Rails 3 project, and want to pluck not only one column,
feel free to use this gem and no need to worry about upgrading to Rails 4, 5, 6 in the future will break this.

## Supports
- Ruby 2.3 ~ 2.7, 3.0 ~ 3.1
- Rails 3.2, 4.2, 5.0, 5.1, 5.2, 6.0, 6.1, 7.0, 7.1

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

Behaves the same as `#pluck` method, but you can use it to pluck multiple columns in Rails 3

```rb
User.where('id < 3').pluck_array(:id, :account)
# => [[1, 'account1'], [2, 'account2']]
```

### pluck to hash

Similar to `#pluck` method, but return array of hashes instead.

```rb
User.where('id < 3').pluck_all(:id, :account)
# => [{"id"=>1, "account"=>"account1"}, {"id"=>2, "account"=>"account2"}]

User.where('id < 3').pluck_all(:id, 'account AS name')
# => [{"id"=>1, "name"=>"account1"}, {"id"=>2, "name"=>"account2"}]

User.where('id < 3').pluck_all('id, account AS name')
# => [{"id"=>1, "name"=>"account1"}, {"id"=>2, "name"=>"account2"}]
```

## Support Mongoid
```rb
class User
  include Mongoid::Document

  field :name, type: String
  field :age, type: Integer
end

User.pluck_all(:name, :age)
# => [
#      {'name' => 'Pearl Shi'   , 'age' => 18},
#      {'name' => 'Rumble Huang', 'age' => 20},
#      {'name' => 'Khiav Reoy'  , 'age' => 20},
#    ]
```


## Benchmark
### Compare with `map` and `as_json`

`pluck_all` return raw `hash` data without loading a bunch of records, in that having better performace than using `map` and `as_json`. The following is the benchmark test on 191,093 users, where `users` table have 51 columns.

```rb
                                       user     system      total        real
map                               36.110000  61.200000  97.310000 ( 99.535375)
select + map                      10.530000   0.660000  11.190000 ( 12.550974)
select + as_json                  49.040000   1.120000  50.160000 ( 55.417534)
pluck_all                          3.310000   0.100000   3.410000 (  3.527775)
```
Test by `benchmark-ips` and `limit 100` in each iteration:
```
Warming up --------------------------------------
                 map     1.000  i/100ms
        select + map    28.000  i/100ms
    select + as_json     7.000  i/100ms
           pluck_all    54.000  i/100ms
Calculating -------------------------------------
                 map     14.230  (± 0.0%) i/s -     72.000  in   5.065349s
        select + map    281.638  (± 4.6%) i/s -      1.428k in   5.081216s
    select + as_json     73.241  (± 4.1%) i/s -    371.000  in   5.076235s
           pluck_all    539.057  (± 6.7%) i/s -      2.700k in   5.034858s

Comparison:
           pluck_all:      539.1 i/s
        select + map:      281.6 i/s - 1.91x  slower
    select + as_json:       73.2 i/s - 7.36x  slower
                 map:       14.2 i/s - 37.88x  slower
```
[test script](https://github.com/khiav223577/pluck_all/issues/18)

### Compare with [pluck_to_hash](https://github.com/girishso/pluck_to_hash) gem

`pluck_all` has better performace since it uses raw `hash` data from `ActiveRecord::Base.connection.select_all`, while `pluck_to_hash` uses `pluck` method, which calls `ActiveRecord::Base.connection.select_all` and transfers the raw `hash` data to `array` format, and then transfer the data to `hash` format again. The following benchmark shows the performance difference:

```rb
                                       user     system      total        real
pluck_to_hash                      2.960000   0.130000   3.090000 (  3.421640)
pluck_all                          2.160000   0.120000   2.280000 (  2.605118)
```
Tested by `benchmark-ips` and `limit 1000` in each iteration:
```
Warming up --------------------------------------
       pluck_to_hash     7.000  i/100ms
           pluck_all     9.000  i/100ms
Calculating -------------------------------------
       pluck_to_hash     84.526  (± 4.7%) i/s -    427.000  in   5.065792s
           pluck_all     95.133  (± 4.2%) i/s -    477.000  in   5.021555s

Comparison:
           pluck_all:       95.1 i/s
       pluck_to_hash:       84.5 i/s - 1.13x  slower
```
See the [test script](https://github.com/khiav223577/pluck_all/issues/18#issuecomment-325407080) for more details.

## Other Support

### Support globalize gem

```rb
class Post < ActiveRecord::Base
  translates :title
end
```

```rb
I18n.locale = :en
Post.pluck_all(:title)
# => [{ 'title' => 'english' }, { 'title' => 'english' }, ...]

I18n.locale = :'zh-TW'
Post.pluck_all(:title)
# => [{ 'title' => '中文' }, { 'title' => '中文' }, ...]
```


### Support Pluck Carrierwave Uploader (if you use carrierwave)
```rb
User.where(xxx).pluck_all(:profile_pic).map{|s| s['profile_pic'] }
```
is the same as
```rb
User.where(xxx).map(&:profile_pic)
```
If the uploader use something like: `model.id`, `model.name`
You may have to send these columns manually:
```rb
User.where(xxx).cast_need_columns(%i[id name]).pluck_all(:id, :name, :profile_pic).map{|s| s['profile_pic'] }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test_active_record` or `rake test_mongoid` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/khiav223577/pluck_all. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

