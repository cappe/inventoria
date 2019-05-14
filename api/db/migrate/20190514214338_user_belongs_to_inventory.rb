class UserBelongsToInventory < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :users, :inventory, foreign_key: true
  end
end
