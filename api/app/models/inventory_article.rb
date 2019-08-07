class InventoryArticle < ApplicationRecord
  belongs_to :inventory
  belongs_to :article
end
