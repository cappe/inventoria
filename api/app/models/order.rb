class Order < ApplicationRecord
  belongs_to :article
  belongs_to :inventory
  belongs_to :product
  belongs_to :user

  STATUSES = %w(pending deliver_now order_delivered)

  enum status: STATUSES

  validates :count,
            presence: true,
            numericality: { minimum: 1 }

  validates :status,
            presence: true,
            inclusion: { in: STATUSES }
end
