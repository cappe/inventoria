class ChangeArticleUniqueConstraints < ActiveRecord::Migration[5.2]
  def change
    add_index :articles, [:gtin, :pid], unique: true
  end
end
