class AddCountToInventoryArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :inventory_articles, :count, :integer, null: false, default: 0
  end
end
