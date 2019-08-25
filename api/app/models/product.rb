class Product < ApplicationRecord
  audited

  belongs_to :article
  belongs_to :inventory

  validates :gtin,
            :lot,
            presence: true,
            length: { maximum: 255 }

  validates :manufacture_date,
            :expiry_date,
            presence: true

  validates :datamatrix,
            presence: true,
            uniqueness: true

  scope :not_used, -> { where(used_at: nil) }
  scope :used, -> { where.not(used_at: nil) }
  scope :order_by_first_to_expire, -> { order(expiry_date: :asc) }

  before_create :write_audit_comment_on_create
  before_destroy :write_audit_comment_on_destroy

  def used?
    !!self.used_at
  end

  def use!
    self.used_at = Time.zone.now
    self.write_audit_comment_on_use
    self.save!
  end

  def unuse!
    self.used_at = nil
    self.write_audit_comment_on_usage_rollback
    self.save!
  end

  def write_audit_comment_on_create
    self.audit_comment = I18n.t('audits.product_audit.create')
  end

  def write_audit_comment_on_use
    self.audit_comment = I18n.t('audits.product_audit.used_from_inventory')
  end

  def write_audit_comment_on_usage_rollback
    self.audit_comment = I18n.t('audits.product_audit.product_usage_rolled_back')
  end

  def write_audit_comment_on_destroy
    self.audit_comment = I18n.t('audits.product_audit.destroy')
  end


  class << self
    def first_to_expire(inventory_id, gtin)
      Product
        .where(inventory_id: inventory_id)
        .where(gtin: gtin)
        .not_used
        .order_by_first_to_expire
        .first
    end
  end
end
