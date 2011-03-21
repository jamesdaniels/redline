module RedLine
	module Customer
		autoload :Settings,        'redline/customer/settings'
		autoload :InstanceMethods, 'redline/customer/instance'
		def self.included(base)
			base.class_eval do
				extend ActiveSupport::Memoizable
				extend RedLine::Customer::Settings
				include InstanceMethods
				memoize :customer
				before_create  :create_customer
				before_update  :update_customer
				before_destroy :delete_customer
				cattr_accessor :braintree_customer_attribute_map
				cattr_accessor :braintree_customer_custom_fields
			end
		end
	end
end
