class Order < ApplicationRecord
  audited

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

  scope :status_is_deliver_now, -> { where(status: :deliver_now) }
  scope :status_is_pending, -> { where(status: :pending) }

  def delivered!
    self.status = :order_delivered
    self.save!
  end
end
