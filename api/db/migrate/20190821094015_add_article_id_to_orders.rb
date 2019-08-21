class AddArticleIdToOrders < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :orders, :article, foreign_key: true
  end
end
