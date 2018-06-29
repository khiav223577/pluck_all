require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

Rake::TestTask.new(:test_active_record) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/active_record/**/*_test.rb']
end

Rake::TestTask.new(:test_mongoid) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/mongoid/**/*_test.rb']
end

task :default => :test
