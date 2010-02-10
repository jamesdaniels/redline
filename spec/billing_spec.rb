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
	
	it 'should run billing' do
		Braintree::Customer.stub!('_create_signature').and_return([:first_name, :last_name, :email])
		Braintree::Customer.should_receive('create!').with(valid_user.braintree_customer_attributes).exactly(3).and_return(mock_customer)
		users = User.subscription_plans.keys.map do |plan|
			user = User.new(
				:first_name => 'James', 
				:last_name => 'Daniels', 
				:email => 'james@marginleft.com', 
				:unused_attribute => 'unused'
			)
			user.plan = plan
			if plan == :mild
				user.should_receive(:next_due).and_return(nil)
				user.should_not_receive(:pay!)
			else
				user.should_receive(:next_due).and_return(Date.today)
				user.should_receive(:pay!).and_return(true)
			end
			user.save
			user
		end
		User.stub!(:all).and_return(users)
		User.run_billing!
	end
	
	describe 'paid bill' do
		(0).upto(5) do |x|
			it "should push the due date 30 days when #{x} days past due" do
				user = User.new
				mock_customer = mock(Braintree::Customer, :id => 1)
				user.stub!('customer').and_return(mock_customer)
				mock_customer.should_receive('sale!').with({:amount=>"10.00", :options=>{:submit_for_settlement=>true}}).and_return(true)
				user.plan = :spicy
				user.paid_until = Date.today - x.days
				user.trial_until = Date.today - 30.days
				user.pay
				user.next_due.should eql(Date.today + 30.days - x.days)
			end
		end
	end
	
end

describe ComplexUser do
	
	describe 'paid bill' do
		(0).upto(5) do |x|
			it "should push the due date 30 days when #{x} days past due" do
				user = ComplexUser.new
				mock_customer = mock(Braintree::Customer, :id => 1)
				user.stub!('customer').and_return(mock_customer)
				mock_customer.should_receive('sale!').with({:amount=>"5.00", :options=>{:submit_for_settlement=>true}}).and_return(true)
				user.plan = :medium
				user.paid_until = Date.today - x.days
				user.trial_until = Date.today - 31.days
				user.pay
				user.next_due.should eql(Date.today + 31.days - x.days)
			end
		end
	end

end

describe UserWithoutTrial do
	
	describe 'paid bill' do
		(0).upto(5) do |x|
			it "should push the due date 30 days when #{x} days past due" do
				user = UserWithoutTrial.new
				mock_customer = mock(Braintree::Customer, :id => 1)
				user.stub!('customer').and_return(mock_customer)
				mock_customer.should_receive('sale!').with({:amount=>"10.00", :options=>{:submit_for_settlement=>true}}).and_return(true)
				user.plan = :spicy
				user.paid_until = Date.today - x.days
				user.pay
				user.next_due.should eql(Date.today + 30.days - x.days)
			end
		end
	end
	
end