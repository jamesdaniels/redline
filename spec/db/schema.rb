ActiveRecord::Schema.define(:version => 1) do
  create_table :users, :force => true do |t|
    t.column :first_name, :string
    t.column :last_name, :string
    t.column :email, :string
    t.column :unused_attribute, :string
    t.column :customer_id, :integer
  end
  create_table :complex_users, :force => true do |t|
    t.column :firstname, :string
    t.column :lastname, :string
    t.column :email, :string
    t.column :unused_attribute, :string
    t.column :customer_id, :integer
  end
end