module RedLine
	module Subscription
		module Settings
			def set_default_subscription_options
				billing_frequency 30.days unless (send :billing_settings)
				free_trial        30.days unless (send :trial_settings)
				default_plan ((send :subscription_plans).to_a.sort_by{|a| a[1][:price]}.first.first) unless (send :default_subscription_plan )
			end
			def plans(subscriptions = {})
				send :include, RedLine::Subscription
				send 'subscription_plans=', subscriptions
			end
			def free_trial(period, options = {})
				send 'trial_settings=', {:period => period, :reminder => 5.days}.merge(options)
			end
			def billing_frequency(period, options = {})
				send 'billing_settings=', {:period => period, :grace_period => 5.days}.merge(options)
			end
			def default_plan(subscription_plan)
				send 'default_subscription_plan=', subscription_plan
			end
		end
	end
end