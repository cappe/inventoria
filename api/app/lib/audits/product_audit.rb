module Audits
  class ProductAudit
    include ActiveModel::Serialization

    attr_accessor :audit,
                  :user,
                  :product,
                  :article

    delegate :id,
             :action,
             :created_at,
             to: :audit

    def initialize(params)
      raise 'audit is missing' unless params[:audit]
      raise 'product is missing' unless params[:product]
      raise 'article is missing' unless params[:article]

      self.audit = params[:audit]
      self.user = params[:user] if params[:user]
      self.product = params[:product]
      self.article = params[:article]
    end

    def product_id
      self.audit.auditable_id
    end

    def comment
      self.audit.comment || I18n.t('audits.product_audit.no_comment')
    end
  end
end
