# frozen_string_literal: true

require 'rails_compatibility/setup_autoload_paths'
RailsCompatibility.setup_autoload_paths [File.expand_path('../models/', __FILE__)]

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.string :name
    t.string :email
    t.string :profile_pic
    t.string :pet_pic
    t.text :serialized_attribute
  end

  create_table :posts, force: true do |t|
    t.integer :user_id
    t.string :name
    t.string :title
  end
end

users = User.create([
  { name: 'John', email: 'john@example.com' },
  { name: 'Pearl', email: 'pearl@example.com', serialized_attribute: { testing: true, deep: { deep: :deep }}},
  { name: 'Doggy', email: 'kathenrie@example.com' },
])

User.where(name: 'John').update_all(profile_pic: 'JohnProfile.jpg') # skip carrierwave
User.where(name: 'Doggy').update_all(profile_pic: 'Profile.jpg', pet_pic: 'Pet.png') # skip carrierwave

Post.create([
  { name: 'post1', title: "John's post1", user_id: users[0].id },
  { name: 'post2', title: "John's post2", user_id: users[0].id },
  { name: 'post3', title: "John's post3", user_id: users[0].id },
  { name: 'post4', title: "Pearl's post1", user_id: users[1].id },
  { name: 'post5', title: "Pearl's post2", user_id: users[1].id },
  { name: 'post6', title: "Doggy's post1", user_id: users[2].id },
  { name: 'post6', title: 'no owner post' },
])

# TODO: wait for globalize to support Rails 7.
SUPPORT_GLOBALIZE = (ActiveRecord::VERSION::MAJOR > 3 && ActiveRecord::VERSION::MAJOR < 7)

if SUPPORT_GLOBALIZE
  require 'globalize'

  ActiveRecord::Schema.define do
    create_table :questionnaires, force: true do |_t|
    end

    Questionnaire.create_translation_table! title: :string
  end

  I18n.available_locales = [:en, :'zh-TW']

  Questionnaire.create.tap do |questionnaire|
    I18n.with_locale(:en){ questionnaire.update(title: 'What is your favorite food?') }
    I18n.with_locale(:'zh-TW'){ questionnaire.update(title: '你最愛的食物為何？') }
  end

  Questionnaire.create.tap do |questionnaire|
    I18n.with_locale(:en){ questionnaire.update(title: 'Why did you purchase this product?') }
  end
end
