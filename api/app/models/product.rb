class Product < ApplicationRecord
  belongs_to :article
  belongs_to :inventory

  validates :gtin,
            :lot,
            presence: true,
            length: { maximum: 255 }

  validates :manufacture_date,
            :expiry_date,
            presence: true

end
