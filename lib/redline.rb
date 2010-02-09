require 'rubygems'
require 'active_record'

module RedLine

	autoload :Customer, 'redline/customer'
	autoload :Subscription, 'redline/subscription'
	
	def has_a_braintree_customer(&block)
		send :include, RedLine::Customer
		block.call if block_given?
		set_default_customer_options
	end
	
	def has_a_subscription(&block)
		send :include, RedLine::Subscription
		yield if block_given?
		set_default_subscription_options
	end

end

ActiveRecord::Base.extend RedLine