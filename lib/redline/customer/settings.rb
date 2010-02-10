module RedLine
	module Customer
		module Settings
			def set_default_customer_options
				attribute_map {} unless (send :braintree_customer)
			end
			def attribute_map(attributes = {})
				self.braintree_customer = attributes
			end
		end
	end
end