class Order < ApplicationRecord
  belongs_to :inventory
  belongs_to :product
  belongs_to :user

  validates :count,
            presence: true,
            numericality: { minimum: 1 }
end
