User.create([
	{:name => 'John', :email => 'john@example.com'},
	{:name => 'pearl', :email => 'pearl@example.com', :serialized_attribute => {:testing => true, :deep => {:deep => :deep}}},
	{:name => 'kathenrie', :email => 'kathenrie@example.com'},
])
