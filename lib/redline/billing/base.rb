module RedLine
	module Billing
		def run_billing!
			# should clean this up, put it in a named scope
			self.all.select{|u| u.next_due == Date.today}.each do |record|
				record.pay rescue nil
				record.save
			end
		end
	end
end