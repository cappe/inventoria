class Article < ApplicationRecord
  has_many :products, dependent: :restrict_with_exception

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
end
