class OrderBelongsToInventory < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :orders, :inventory, foreign_key: true
  end
end
