require 'rubygems'
require 'active_record'

module RedLine
  
  autoload :Customer, 'redline/customer'
	
	def acts_as_braintree_customer(attribute_rewriting = {})
		send :include, RedLine::Customer
		send 'braintree_customer=', attribute_rewriting
	end

end

ActiveRecord::Base.extend RedLine