module RedLine
	module Customer
		module Settings
			def set_default_customer_options
				attribute_map unless (send :braintree_customer_attribute_map)
				custom_fields unless (send :braintree_customer_custom_fields)
			end
			def attribute_map(attributes = {})
				self.braintree_customer_attribute_map = attributes
			end
			def custom_fields(*attributes)
				self.braintree_customer_custom_fields = attributes
			end
		end
	end
end