class User < ActiveRecord::Base
	
	acts_as_braintree_customer
	
	validates_presence_of :first_name, :last_name, :unused_attribute, :email

end

class ComplexUser < ActiveRecord::Base
	
	acts_as_braintree_customer :firstname => :first_name, :lastname => :last_name
	
	validates_presence_of :firstname, :lastname, :unused_attribute, :email
	
end