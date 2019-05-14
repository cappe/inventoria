class ProductBelongsToInventory < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :products, :inventory, foreign_key: true
  end
end
