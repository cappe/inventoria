class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :count, null: false, default: 1

      t.belongs_to :product, foreign_key: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
