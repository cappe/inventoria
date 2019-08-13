class Api::V1::InventoryArticleSerializer < ApplicationSerializer
  attributes :id,
             :inventory_id,
             :article_id,
             :count
end
