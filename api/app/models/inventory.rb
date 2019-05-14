class Inventory < ApplicationRecord
  has_many :orders, dependent: :restrict_with_exception
  has_many :products, dependent: :restrict_with_exception
  has_many :users, dependent: :restrict_with_exception

  validates :name,
            presence: true
end
