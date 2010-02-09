module RedLine
	module Subscription
		def self.included(base)
			base.class_eval do
				send :extend, ActiveSupport::Memoizable
				send :extend, RedLine::Subscription::Settings
				send :include, InstanceMethods
				send :before_create, :set_plan
				cattr_accessor :subscription_plans, :trial_settings, :billing_settings, :default_subscription_plan
			end
		end
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
		module InstanceMethods
			def plan
				self.class.subscription_plans[(subscription_key || self.class.default_subscription_plan).to_sym]
			end
			def plan=(plan)
				if (plan.is_a?(String) || plan.is_a?(Symbol)) && self.class.subscription_plans.keys.include?(plan.to_sym)
					self.subscription_key = plan
				elsif plan.is_a?(Hash)
					self.subscription_key = self.class.subscription_plans.index(plan)
				end
				self.paid_until = Date.today
				self.trial_until ||= Date.today + self.class.trial_settings[:period] if trial?
			end
			def set_plan
				self.subscription_key ||= self.class.default_subscription_plan
			end
			def pay
				self.customer.sale!(:amount => ("%0.2f" % plan[:price]), :options => {:submit_for_settlement => true})
				self.paid_until = Date.today + self.class.billing_settings[:period] - (past_due || 0)
			end
			def past_grace?
				past_due && past_due >= self.class.billing_settings[:grace_period]
			end
			def paid_plan?
				plan[:price] > 0
			end
			def trial?
				self.class.trial_settings[:period] > 0.days
			end
			def next_due
				paid_plan? && [trial? && trial_until || nil, paid_until, Date.today].compact.max
			end
			def past_due
				due_date = [trial? && trial_until || nil, paid_until].compact.max
				amount = (due_date && (Date.today - due_date) || 0).days
				paid_plan? && amount > 0 && amount
			end
		end
	end
end