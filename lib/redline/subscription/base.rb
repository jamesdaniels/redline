module RedLine
	module Subscription
		autoload :Settings,        'redline/subscription/settings'
		autoload :InstanceMethods, 'redline/subscription/instance'
		def self.included(base)
			base.class_eval do
				extend ActiveSupport::Memoizable
				extend RedLine::Subscription::Settings
				extend RedLine::Billing
				include InstanceMethods
				before_create :set_plan
				cattr_accessor :subscription_plans, :trial_settings, :billing_settings, :default_subscription_plan
			end
		end
	end
end