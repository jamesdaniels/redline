require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActiveRecord do
	it 'should extend our module' do
		ActiveRecord::Base.is_a?(RedLine).should be_true
	end
end

[User, ComplexUser, UserWithoutTrial, UserWithoutSubscription].each do |klass|
	describe klass do
		it 'should extend our module' do
			klass.is_a?(RedLine).should be_true
		end
		it 'should respond to a customer' do
			klass.respond_to?(:has_a_braintree_customer).should be_true
		end
		it 'should respond to a subscription' do
			klass.respond_to?(:has_a_subscription).should be_true
		end
		it 'should include RedLine::Customer' do
			klass.include?(RedLine::Customer).should be_true
		end
		it 'should extend RedLine::Customer::Settings' do
			klass.is_a?(RedLine::Customer::Settings).should be_true
		end
		it 'should include RedLine::Customer::InstanceMethods' do
			klass.include?(RedLine::Customer::InstanceMethods).should be_true
		end
		it "should#{(klass == UserWithoutSubscription) && ' not' || ''} include RedLine::Subscription" do
			klass.include?(RedLine::Subscription).should eql(klass != UserWithoutSubscription)
		end
		it "should#{(klass == UserWithoutSubscription) && ' not' || ''} extend RedLine::Subscription::Settings" do
			klass.is_a?(RedLine::Subscription::Settings).should eql(klass != UserWithoutSubscription)
		end
		it "should#{(klass == UserWithoutSubscription) && ' not' || ''} include RedLine::Subscription::InstanceMethods" do
			klass.include?(RedLine::Subscription::InstanceMethods).should eql(klass != UserWithoutSubscription)
		end
		it "should#{(klass == UserWithoutSubscription) && ' not' || ''} include RedLine::Billing" do
			klass.is_a?(RedLine::Billing).should eql(klass != UserWithoutSubscription)
		end
	end
end