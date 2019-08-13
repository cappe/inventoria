class InventoryArticle < ApplicationRecord
  belongs_to :inventory
  belongs_to :article

  validates :count,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 255
            }
end
