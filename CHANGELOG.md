## Change Log

### [v2.1.0](https://github.com/khiav223577/pluck_all/compare/v2.0.4...v2.1.0) 2020/10/19
- [#47](https://github.com/khiav223577/pluck_all/pull/47) Use instantiate method to initialize model without calling callbacks (@khiav223577)
- [#45](https://github.com/khiav223577/pluck_all/pull/45) Support Ruby 2.7 (@khiav223577)
- [#44](https://github.com/khiav223577/pluck_all/pull/44) Move `require` from begin..rescue block for better debug message (@khiav223577)
- [#43](https://github.com/khiav223577/pluck_all/pull/43) Use rails_compatibility to get attribute_types for better compatibility (@khiav223577)
- [#41](https://github.com/khiav223577/pluck_all/pull/41) Support Rails 6.0 (@khiav223577)

### [v2.0.4](https://github.com/khiav223577/pluck_all/compare/v2.0.3...v2.0.4) 2019/04/04
- [#40](https://github.com/khiav223577/pluck_all/pull/40) Fix: inconsistent with pluck when having `select` on relation (@khiav223577)
- [#39](https://github.com/khiav223577/pluck_all/pull/39) Fix: undefined local variable or method `construct_relation_for_association_calculations` in Rails 5.2.2.1 (@MasashiYokota)
- [#36](https://github.com/khiav223577/pluck_all/pull/36) Fix: broken test cases after bundler 2.0 was released (@khiav223577)
- [#35](https://github.com/khiav223577/pluck_all/pull/35) refactor #test_pluck_with_includes (@khiav223577)
- [#34](https://github.com/khiav223577/pluck_all/pull/34) Provide Arel support as well (@snkashis)
- [#33](https://github.com/khiav223577/pluck_all/pull/33) Fix gemfile path in bin/setup (@snkashis)
- [#32](https://github.com/khiav223577/pluck_all/pull/32) Move patches into separate files (@khiav223577)

### [v2.0.3](https://github.com/khiav223577/pluck_all/compare/v2.0.2...v2.0.3) 2018/07/19
- [#30](https://github.com/khiav223577/pluck_all/pull/30) Fix: includes + pluck_all results in strange output (@khiav223577)

### [v2.0.2](https://github.com/khiav223577/pluck_all/compare/v2.0.1...v2.0.2) 2018/06/29
- [#28](https://github.com/khiav223577/pluck_all/pull/28) Fix test cases and the result format may be wrong when plucking multiple columns with nil value may (@khiav223577)
- [#27](https://github.com/khiav223577/pluck_all/pull/27) [Feature] Mongoid Hooks And Tests Separation (@berniechiu)
- [#26](https://github.com/khiav223577/pluck_all/pull/26) [FIX] Wrong Module Skipped (@berniechiu)

### [v2.0.1](https://github.com/khiav223577/pluck_all/compare/v2.0.0...v2.0.1) 2018/05/27
- [#25](https://github.com/khiav223577/pluck_all/pull/25) Fix that project without mongoid will raise LoadError (@khiav223577)

### [v2.0.0](https://github.com/khiav223577/pluck_all/compare/v1.2.4...v2.0.0) 2018/05/27
- [#24](https://github.com/khiav223577/pluck_all/pull/24) Support Mongoid! (@khiav223577)
- [#23](https://github.com/khiav223577/pluck_all/pull/23) Refactoring Coding Style (@khiav223577)
- [#22](https://github.com/khiav223577/pluck_all/pull/22) test Rails 5.2 (@khiav223577)
- [#21](https://github.com/khiav223577/pluck_all/pull/21) should test both 5.0.x and 5.1.x (@khiav223577)
- [#20](https://github.com/khiav223577/pluck_all/pull/20) test pluck_all in rails 5.1.x (@khiav223577)
- [#19](https://github.com/khiav223577/pluck_all/pull/19) add test cases to test `join` with table name and `alias` (@khiav223577)

### [v1.2.4](https://github.com/khiav223577/pluck_all/compare/v1.2.3...v1.2.4) 2017/04/11
- [#17](https://github.com/khiav223577/pluck_all/pull/17) supports carrierwave 1.0.0 (@khiav223577)

### [v1.2.3](https://github.com/khiav223577/pluck_all/compare/v1.2.2...v1.2.3) 2017/04/03
- [#14](https://github.com/khiav223577/pluck_all/pull/14) use mass assign to assign values (@khiav223577)
- [#16](https://github.com/khiav223577/pluck_all/pull/16) Checking if Class has CarrierWave loaded (@basex)
- [#15](https://github.com/khiav223577/pluck_all/pull/15) Restrict dependency to activerecord (@basex)

### [v1.2.2](https://github.com/khiav223577/pluck_all/compare/v1.2.1...v1.2.2) 2017/03/14
- [#13](https://github.com/khiav223577/pluck_all/pull/13) Model.none.pluck_all(..) should return empty array instead of raising exception (@khiav223577)
- [#12](https://github.com/khiav223577/pluck_all/pull/12) test other ruby version (@khiav223577)

### [v1.2.1](https://github.com/khiav223577/pluck_all/compare/v1.2.0...v1.2.1) 2017/01/24
- [#11](https://github.com/khiav223577/pluck_all/pull/11) always return carrierwave uploader if possible (@khiav223577)
- [#10](https://github.com/khiav223577/pluck_all/pull/10) change pluck_all return value of carrierwave column (@khiav223577)

### [v1.2.0](https://github.com/khiav223577/pluck_all/compare/v1.1.2...v1.2.0) 2017/01/24
- [#5](https://github.com/khiav223577/pluck_all/pull/5) Support casting CarrierWave url (@khiav223577)
- [#9](https://github.com/khiav223577/pluck_all/pull/9) need ActiveRecord version not Rails version (@khiav223577)
- [#8](https://github.com/khiav223577/pluck_all/pull/8) Upgrade rake version in development (@khiav223577)

### [v1.1.2](https://github.com/khiav223577/pluck_all/compare/v1.1.1...v1.1.2) 2017/01/06
- [#7](https://github.com/khiav223577/pluck_all/pull/7) fix pluck_all with join (@khiav223577)

### [v1.1.1](https://github.com/khiav223577/pluck_all/compare/v1.1.0...v1.1.1) 2017/01/01
- [#4](https://github.com/khiav223577/pluck_all/pull/4) add code climate (@khiav223577)

### [v1.1.0](https://github.com/khiav223577/pluck_all/compare/v1.0.1...v1.1.0) 2016/12/21
- [#3](https://github.com/khiav223577/pluck_all/pull/3) Feature/pluck array (@khiav223577)

### [v1.0.1](https://github.com/khiav223577/pluck_all/compare/v1.0.0...v1.0.1) 2016/12/20
- [#2](https://github.com/khiav223577/pluck_all/pull/2) test with multiple rails version (@khiav223577)
- [#1](https://github.com/khiav223577/pluck_all/pull/1) add basic test cases (@khiav223577)
