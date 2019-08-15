class AddIndexOnProductAttributes < ActiveRecord::Migration[5.2]
  def change
    add_index :products, :gtin
    add_index :products, :lot
  end
end
