require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe User do
	
	def valid_user
		Braintree::Customer.stub!('_create_signature').and_return([:first_name, :last_name, :email])
		@user ||= User.new(
			:first_name => 'James', 
			:last_name => 'Daniels', 
			:email => 'james@marginleft.com', 
			:unused_attribute => 'unused'
		)
	end
	
	def mock_customer
		@customer ||= mock(Braintree::Customer, :id => 1)
	end
	
	it "should have a empty braintree_customer" do
		User.braintree_customer.should eql({})
	end
	
  it "should inherit the instance methods" do
		expected_methods = %w(braintree_customer_attributes customer create_customer update_customer delete_customer)
		(User.instance_methods & expected_methods).sort.should eql(expected_methods.sort)
	end
	it "should have proper braintree attributes" do
		valid_user.braintree_customer_attributes.should eql({:first_name=>"James", :last_name=>"Daniels", :email=>"james@marginleft.com"})
	end
	it "should fire Braintree::Customer.create!" do
		Braintree::Customer.should_receive('create!').with(valid_user.braintree_customer_attributes).and_return(mock_customer)
		valid_user.save!
		valid_user.reload
		valid_user.customer_id.should eql(mock_customer.id)
	end
	it "should fire Braintree::Customer.update!" do
		Braintree::Customer.stub!('create!').and_return(mock_customer)
		Braintree::Customer.should_receive('update!').with(mock_customer.id, valid_user.braintree_customer_attributes.merge(:email =>  'james@jamesdaniels.net')).and_return(true)
		valid_user.save!
		valid_user.update_attributes(:email => 'james@jamesdaniels.net')
		valid_user.reload
		valid_user.customer_id.should eql(mock_customer.id)
	end
	it "should fire Braintree::Customer.delete" do
		Braintree::Customer.stub!('create!').and_return(mock_customer)
		Braintree::Customer.stub!('find').and_return(true)
		Braintree::Customer.should_receive('delete').with(mock_customer.id).and_return(true)
		valid_user.save!
		valid_user.destroy
	end
	it "should fire Braintree::Customer.find" do
		Braintree::Customer.stub!('create!').and_return(mock_customer)
		Braintree::Customer.stub!('update!').and_return(true)
		Braintree::Customer.should_receive('find').with(mock_customer.id).and_return(true)
		valid_user.save!
		valid_user.customer
	end
	
end

describe ComplexUser do
	
	it "should have a empty braintree_customer" do
		ComplexUser.braintree_customer.should eql({:firstname=>:first_name, :lastname=>:last_name})
	end
	it "should have proper braintree attributes" do
		Braintree::Customer.stub!('_create_signature').and_return([:first_name, :last_name, :email])
		ComplexUser.new(
			:firstname => 'James', 
			:lastname => 'Daniels', 
			:email => 'james@marginleft.com', 
			:unused_attribute => 'unused'
		).braintree_customer_attributes.should eql({:first_name=>"James", :last_name=>"Daniels", :email=>"james@marginleft.com"})
	end

end