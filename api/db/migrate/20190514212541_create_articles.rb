class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :name, null: false
      t.string :pid, null: false
      t.string :gtin13, null: false
      t.string :gtin14, null: false
      t.string :unit, null: false

      t.index :pid, unique: true
      t.index :gtin13, unique: true
      t.index :gtin14, unique: true

      t.timestamps
    end
  end
end
