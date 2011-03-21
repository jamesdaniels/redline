module RedLine
	module Customer
		module InstanceMethods
			def braintree_customer_attributes
				wanted_attributes = Braintree::Customer._attributes - [:id, :created_at, :updated_at, :credit_cards, :addresses]
				wanted_attributes.inject({}) {|hash, key| hash.merge(key => (self.send(self.class.braintree_customer_attribute_map[key] || key) rescue nil))}.
					merge(:custom_fields => self.class.braintree_customer_custom_fields.inject({}) {|hash, key| hash.merge(key => (self.send(self.class.braintree_customer_attribute_map[key] || key) rescue nil))}).
						reject { |key, value| value == {}}
			end
			def customer
				Braintree::Customer.find(customer_id) if customer_id
			end
			def create_customer
				self.customer_id ||= Braintree::Customer.create!(braintree_customer_attributes).id
			end
			def update_customer
				Braintree::Customer.update!(customer_id, braintree_customer_attributes) && flush_cache(:customer) if customer_id
			end
			def delete_customer
				if customer_id
					Braintree::Customer.delete(customer_id)
					self.customer_id = nil
				end
			end
		end
	end
end
