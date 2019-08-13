class Article < ApplicationRecord
  has_many :products, dependent: :restrict_with_error
  has_many :inventory_articles, dependent: :restrict_with_error

  validates :name,
            :unit,
            presence: true,
            length: { maximum: 255 }

  validates :pid,
            :gtin13,
            :gtin14,
            presence: true,
            length: { maximum: 255 },
            uniqueness: true

  scope :with_products_in_inventory, -> (inventory) {
    includes(:products)
      .where(products: {
        inventory: inventory,
      })
      .merge(Product.not_used)
  }
end
