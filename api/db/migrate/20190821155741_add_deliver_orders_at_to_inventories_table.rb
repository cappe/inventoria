class AddDeliverOrdersAtToInventoriesTable < ActiveRecord::Migration[5.2]
  def self.up
    add_column :inventories, :deliver_orders_every, :integer

    Inventory
      .where(deliver_orders_every: nil)
      .update_all({ deliver_orders_every: 0 })

    change_column_null :inventories, :deliver_orders_every, false
  end

  def self.down
    remove_column :inventories, :deliver_orders_every
  end
end
