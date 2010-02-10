require 'rubygems'
require 'active_record'

module RedLine

	autoload :Customer,     'redline/customer/base'
	autoload :Subscription, 'redline/subscription/base'
	autoload :Billing,      'redline/billing/base'
	
	def has_a_braintree_customer
		send :include, RedLine::Customer
		yield if block_given?
		set_default_customer_options
	end
	
	def has_a_subscription
		send :include, RedLine::Subscription
		yield if block_given?
		set_default_subscription_options
	end

end

ActiveRecord::Base.extend RedLine