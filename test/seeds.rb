users = User.create([
  {:name => 'John', :email => 'john@example.com'},
  {:name => 'Pearl', :email => 'pearl@example.com', :serialized_attribute => {:testing => true, :deep => {:deep => :deep}}},
  {:name => 'Kathenrie', :email => 'kathenrie@example.com'},
])
Post.create([
  {:title => 'John\'s post1', :user_id => users[0].id},
  {:title => 'John\'s post2', :user_id => users[0].id},
  {:title => 'John\'s post3', :user_id => users[0].id},
  {:title => 'Pearl\'s post1', :user_id => users[1].id},
])
