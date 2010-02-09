module RedLine
	module Customer
		autoload :Settings,        'redline/customer/settings'
		autoload :InstanceMethods, 'redline/customer/instance'
		def self.included(base)
			base.class_eval do
				send :extend, ActiveSupport::Memoizable
				send :extend, RedLine::Customer::Settings
				send :include, InstanceMethods
				memoize :customer
				before_create  :create_customer
				before_update  :update_customer
				before_destroy :delete_customer
				cattr_accessor :braintree_customer
			end
		end
	end
end