# frozen_string_literal: true

ActiveSupport::Dependencies.autoload_paths << File.expand_path('../models/', __FILE__)

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

  create_table :questionnaires, force: true do |t|
    # t.string :
  end

  Questionnaire.create_translation_table! title: :string
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

I18n.available_locales = [:en, :'zh-TW']

Questionnaire.create.tap do |questionnaire|
  I18n.with_locale(:en){ questionnaire.update(title: 'What is your favorite food?') }
  I18n.with_locale(:'zh-TW'){ questionnaire.update(title: '你最愛的食物為何？') }
end

Questionnaire.create.tap do |questionnaire|
  I18n.with_locale(:en){ questionnaire.update(title: 'Why did you purchase this product?') }
end
