ActiveRecord::Schema.define(:version => 1) do
	create_table :users, :force => true do |t|
		t.column :first_name, :string
		t.column :last_name, :string
		t.column :email, :string
		t.column :unused_attribute, :string
		t.column :customer_id, :integer
		t.column :subscription_key, :string
		t.column :trial_until, :date
		t.column :paid_until, :date
	end
	create_table :complex_users, :force => true do |t|
		t.column :firstname, :string
		t.column :lastname, :string
		t.column :email, :string
		t.column :unused_attribute, :string
		t.column :customer_id, :integer
		t.column :subscription_key, :string
		t.column :trial_until, :date
		t.column :paid_until, :date
	end
	create_table :user_without_trials, :force => true do |t|
		t.column :firstname, :string
		t.column :lastname, :string
		t.column :email, :string
		t.column :unused_attribute, :string
		t.column :customer_id, :integer
		t.column :subscription_key, :string
		t.column :paid_until, :date
	end
	create_table :user_without_subscription, :force => true do |t|
		t.column :firstname, :string
		t.column :lastname, :string
		t.column :email, :string
		t.column :customer_id, :integer
	end
end