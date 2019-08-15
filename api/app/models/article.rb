class Article < ApplicationRecord
  has_many :products, dependent: :restrict_with_error
  has_many :inventory_articles, dependent: :restrict_with_error

  validates :name,
            :unit,
            presence: true,
            length: { maximum: 255 }

  validates :pid,
            :gtin,
            presence: true,
            length: { maximum: 255 }

  validates :gtin,
            uniqueness: { scope: :pid }
end
