$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pluck_all'

require 'minitest/autorun'


ActiveRecord::Base.establish_connection(
  "adapter"  => "sqlite3",
  "database" => ":memory:"
)
ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, :force => true do |t|
    t.integer :id
    t.string :name
    t.string :email
    t.text :serialized_attribute
  end
  create_table :posts, :force => true do |t|
    t.integer :id
    t.string :title
  end
end
class User < ActiveRecord::Base
  serialize :serialized_attribute, Hash
  has_many :posts
end
class Post < ActiveRecord::Base
  belongs_to :user
end
require 'seeds'
