class User < ActiveRecord::Base
	
	has_a_braintree_customer
	
	has_a_subscription do
		plans :mild => {:price => 0.00}, :medium => {:price => 5.00}, :spicy => {:price => 10.00}
	end
	
	validates_presence_of :first_name, :last_name, :unused_attribute, :email

end

class ComplexUser < ActiveRecord::Base
	
	has_a_braintree_customer do
		attribute_map :firstname => :first_name, :lastname => :last_name
	end
	
	has_a_subscription do
		plans :mild => {:price => 0.00}, :medium => {:price => 5.00}, :spicy => {:price => 10.00}
		default_plan :medium
		billing_frequency 31.days, :grace_period => 6.days
		free_trial 31.days, :reminder => 6.days
	end
	
	validates_presence_of :firstname, :lastname, :unused_attribute, :email
	
end

class UserWithoutTrial < ActiveRecord::Base
	
	has_a_braintree_customer
	
	has_a_subscription do
		plans :mild => {:price => 0.00}, :medium => {:price => 5.00}, :spicy => {:price => 10.00}
		free_trial 0.days
	end
	
end