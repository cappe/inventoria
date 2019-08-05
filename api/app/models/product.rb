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

  scope :not_used, -> { where(used_at: nil) }
  scope :used, -> { where.not(used_at: nil) }

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

  def write_audit_comment_on_create
    self.audit_comment = I18n.t('audits.product_audit.create')
  end

  def write_audit_comment_on_use
    self.audit_comment = I18n.t('audits.product_audit.used_from_inventory')
  end

  def write_audit_comment_on_destroy
    self.audit_comment = I18n.t('audits.product_audit.destroy')
  end

  def manufacture_date=(manufacture_date)
    if manufacture_date.length == 6
      manufacture_date = "20#{manufacture_date}"
    end

    super manufacture_date
  end

  def expiry_date=(expiry_date)
    if expiry_date.length == 6
      expiry_date = "20#{expiry_date}"
    end

    super expiry_date
  end
end
