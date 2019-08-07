class CreateInventoryArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :inventory_articles do |t|
      t.belongs_to :inventory, foreign_key: true
      t.belongs_to :article, foreign_key: true

      t.timestamps
    end
  end
end
