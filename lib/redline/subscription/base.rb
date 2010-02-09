module RedLine
	module Subscription
		autoload :Settings,        'redline/subscription/settings'
		autoload :InstanceMethods, 'redline/subscription/instance'
		def self.included(base)
			base.class_eval do
				send :extend, ActiveSupport::Memoizable
				send :extend, RedLine::Subscription::Settings
				send :extend, RedLine::Billing
				send :include, InstanceMethods
				send :before_create, :set_plan
				cattr_accessor :subscription_plans, :trial_settings, :billing_settings, :default_subscription_plan
			end
		end
	end
end