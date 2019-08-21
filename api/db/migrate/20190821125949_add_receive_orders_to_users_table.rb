class AddReceiveOrdersToUsersTable < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :receive_orders, :boolean, default: false, null: false
  end
end
