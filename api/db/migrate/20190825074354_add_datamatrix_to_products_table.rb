class AddDatamatrixToProductsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :datamatrix, :string, null: false
    add_index :products, :datamatrix, unique: true
  end
end
