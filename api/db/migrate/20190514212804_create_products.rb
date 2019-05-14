class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :gtin, null: false
      t.string :lot, null: false

      t.boolean :used, default: false, null: false

      t.datetime :manufacture_date, null: false
      t.datetime :expiry_date, null: false
      t.datetime :used_at

      t.belongs_to :article, foreign_key: true

      t.timestamps
    end
  end
end
