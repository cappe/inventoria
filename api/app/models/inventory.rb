class Inventory < ApplicationRecord
  has_many :orders, dependent: :restrict_with_error
  has_many :products, dependent: :restrict_with_error
  has_many :users, dependent: :restrict_with_error
  has_many :inventory_articles, dependent: :restrict_with_error

  DELIVERY_OPTIONS = %w(
    monday
    tuesday
    wednesday
    thursday
    friday
  )

  enum deliver_orders_every: DELIVERY_OPTIONS

  validates :name,
            presence: true,
            length: { maximum: 255 }

  validates :deliver_orders_every,
            presence: true,
            inclusion: { in: DELIVERY_OPTIONS }

  scope :delivery_schedule_is, -> (day) { where(deliver_orders_every: day) }
end
