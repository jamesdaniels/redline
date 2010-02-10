module RedLine
	module Subscription
		module Settings
			def set_default_subscription_options
				billing_frequency 30.days unless billing_settings
				free_trial        30.days unless trial_settings
				default_plan ((send :subscription_plans).to_a.sort_by{|a| a[1][:price]}.first.first) unless default_subscription_plan
			end
			def plans(subscriptions = {})
				include RedLine::Subscription
				self.subscription_plans = subscriptions
			end
			def free_trial(period, options = {})
				self.trial_settings = {:period => period, :reminder => 5.days}.merge(options)
			end
			def billing_frequency(period, options = {})
				self.billing_settings = {:period => period, :grace_period => 5.days}.merge(options)
			end
			def default_plan(subscription_plan)
				self.default_subscription_plan = subscription_plan
			end
		end
	end
end