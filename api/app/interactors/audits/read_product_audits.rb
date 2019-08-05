module Audits
  class ReadProductAudits
    include Interactor

    def call
      products = context
                   .current_inventory
                   .products
                   .includes(:article, :audits)

      audits = products.reduce([]) do |memo, product|
        memo.concat(product.audits)

        memo
      end

      user_ids = audits.map(&:user_id).uniq
      users = context.current_inventory.users.where(id: user_ids)

      product_audits = audits.map do |audit|
        user = users.detect { |u| u.id == audit.user_id }
        product = products.detect { |p| p.id == audit.auditable_id }

        ProductAudit.new({
          audit: audit,
          user: user,
          product: product,
          article: product.article
        })
      end

      context.product_audits = product_audits
    end
  end
end
