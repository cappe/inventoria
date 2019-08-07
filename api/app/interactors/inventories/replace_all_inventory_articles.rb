module Inventories
  class ReplaceAllInventoryArticles
    include Interactor

    def call
      inventory_id = context.current_inventory.id

      InventoryArticle
        .where(inventory_id: inventory_id)
        .delete_all

      now = Time.zone.now

      values = context.article_ids.reduce([]) do |memo, article_id|
        memo << "('#{inventory_id}', '#{article_id}', '#{now}', '#{now}')"
        memo
      end.join(', ')

      return unless values && values.length > 0

      sql = <<-HEREDOC
          INSERT INTO "inventory_articles" ("inventory_id", "article_id", "created_at", "updated_at")
          VALUES #{values};
      HEREDOC

      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
