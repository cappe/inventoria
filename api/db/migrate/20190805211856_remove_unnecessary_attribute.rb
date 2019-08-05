class RemoveUnnecessaryAttribute < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :used
  end
end
