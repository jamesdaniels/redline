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
	
	it 'should have a default plan' do
		Braintree::Customer.should_receive('create!').with(valid_user.braintree_customer_attributes).and_return(mock_customer)
		user = valid_user
		user.save
		user.reload
		user.subscription_key = :mild
	end
	
	it 'should have possible subscription plans' do
		User.subscription_plans.should == {:mild => {:price => 0.00}, :medium => {:price => 5.00}, :spicy => {:price => 10.00}}
	end
	it 'should have a default plan' do
		User.default_subscription_plan.should eql(:mild)
	end
	it 'should have billing settings' do
		User.billing_settings.should == {:period => 30.days, :grace_period => 5.days}
	end
	it 'should have trial settings' do
		User.trial_settings.should == {:period => 30.days, :reminder=>5.days}
	end
	
	describe 'should handle trial period' do
		it 'sets trial' do
			user = User.new
			user.plan = :mild
			user.trial_until.should eql(Date.today + 30.days)
		end
		it 'upgrades account within trial' do
			user = User.new
			user.plan = :medium
			user.plan = :spicy
			user.trial_until.should eql(Date.today + 30.days)
		end
		it 'upgrades account outside of trial' do
			user = User.new
			user.plan = :medium
			user.trial_until = Date.today-1.days
			user.plan = :spicy
			user.trial_until.should eql(Date.today - 1.days)
		end
		it 'downgrades account within trial' do
			user = User.new
			user.plan = :spicy
			user.plan = :medium
			user.trial_until.should eql(Date.today + 30.days)
		end
		it 'downgrades account outside of trial' do
			user = User.new
			user.plan = :spicy
			user.trial_until = Date.today-1.days
			user.plan = :medium
			user.trial_until.should eql(Date.today - 1.days)
		end
	end
end

describe ComplexUser do
	
	it 'should have possible subscription plans' do
		ComplexUser.subscription_plans.should == {:mild => {:price => 0.00}, :medium => {:price => 5.00}, :spicy => {:price => 10.00}}
	end
	it 'should have a default plan' do
		ComplexUser.default_subscription_plan.should eql(:medium)
	end
	it 'should have billing settings' do
		ComplexUser.billing_settings.should == {:period => 31.days, :grace_period => 6.days}
	end
	it 'should have trial settings' do
		ComplexUser.trial_settings.should == {:period => 31.days, :reminder=>6.days}
	end

	it 'should hand plan as a hash' do
		user = ComplexUser.new
		user.plan = ComplexUser.subscription_plans.values.first
		user.subscription_key.should eql(ComplexUser.subscription_plans.keys.first)
	end

	describe 'should handle next due correctly' do
		it 'on free' do
			user = ComplexUser.new
			user.plan = :mild
			user.next_due.should be_false
		end
		it 'on past due' do
			user = ComplexUser.new
			user.plan = :spicy
			user.paid_until = Date.today - 6.days
			user.trial_until = Date.today - 37.days
			user.next_due.should eql(Date.today)
		end
		it 'on paid' do
			user = ComplexUser.new
			user.plan = :spicy
			user.paid_until = Date.today + 6.days
			user.trial_until = Date.today - 31.days + 6.days
			user.next_due.should eql(Date.today+6.days)
		end
		it 'on upgrade' do
			user = ComplexUser.new
			user.plan = :mild
			user.trial_until = Date.today - 30.days
			user.paid_until = Date.today - 1.days
			user.plan = :spicy
			user.next_due.should eql(Date.today)
		end
		it 'on downgrade' do
			user = ComplexUser.new
			user.plan = :spicy
			user.trial_until = Date.today - 30.days
			user.paid_until = Date.today - 1.days
			user.plan = :medium
			user.next_due.should eql(Date.today)
		end
	end
	
	describe 'should handle trial period' do
		it 'sets trial' do
			user = ComplexUser.new
			user.plan = :mild
			user.trial_until.should eql(Date.today + 31.days)
		end
	end
	
	describe 'should handle grace period' do
		it 'on not past due' do
			user = ComplexUser.new
			user.should_receive(:past_due).and_return(false)
			user.past_grace?.should be_false
		end
		0.upto(6) do |x|
			it "on past due by #{x} days" do
				user = ComplexUser.new
				user.should_receive(:past_due).twice.and_return(x.days)
				user.past_grace?.should eql(x > 5)
			end
		end
	end

	describe 'should handle due correctly' do
	 	describe 'past due' do
			it 'should work via past_due method' do
				user = ComplexUser.new
				user.plan = :spicy
				user.paid_until = Date.today - 6.days
				user.trial_until = Date.today - 37.days
				user.past_due.should eql(6.days)
			end
			it 'should handle trials' do
				user = ComplexUser.new
				user.plan = :spicy
				user.paid_until = nil
				user.trial_until = Date.today - 1.days
				user.past_due.should eql(1.days)
			end
		end
		describe 'not overdue' do
			it 'should work via past_due method' do
				user = ComplexUser.new
				user.plan = :spicy
				user.paid_until = Date.today + 6.days
				user.trial_until = Date.today - 31.days + 6.days
				user.past_due.should be_false
			end
			it 'should handle end of trial' do
				user = ComplexUser.new
				user.plan = :spicy
				user.paid_until = nil
				user.trial_until = nil
				user.past_due.should be_false
			end
			it 'should handle trials' do
				user = ComplexUser.new
				user.plan = :spicy
				user.paid_until = nil
				user.trial_until = Date.today + 1.days
				user.past_due.should be_false
			end
		end
		describe 'free account' do
			it 'should work via past_due trial' do
				user = ComplexUser.new
				user.plan = :mild
				user.paid_until = Date.today - 6.days
				user.trial_until = Date.today - 37.days
				user.past_due.should be_false
			end
			it 'should handle past_due trials' do
				user = ComplexUser.new
				user.plan = :mild
				user.paid_until = nil
				user.trial_until = Date.today - 1.days
				user.past_due.should be_false
			end
			it 'should work via trial' do
				user = ComplexUser.new
				user.plan = :mild
				user.paid_until = Date.today + 6.days
				user.trial_until = Date.today - 31.days + 6.days
				user.past_due.should be_false
			end
			it 'should handle trials' do
				user = ComplexUser.new
				user.plan = :mild
				user.paid_until = nil
				user.trial_until = Date.today + 1.days
				user.past_due.should be_false
			end
		end
	end

end

describe UserWithoutTrial do
	
	it 'has no trial' do
		UserWithoutTrial.trial_settings.should == {:period=>0.days, :reminder=>5.days}
	end

end