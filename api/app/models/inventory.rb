class Inventory < ApplicationRecord
  has_many :orders, dependent: :restrict_with_error
  has_many :products, dependent: :restrict_with_error
  has_many :users, dependent: :restrict_with_error
  has_many :inventory_articles, dependent: :restrict_with_error

  validates :name,
            presence: true,
            length: { maximum: 255 }
end
