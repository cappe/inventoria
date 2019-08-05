module Inventories
  class UseProduct
    include Interactor

    def call
      product = context.current_inventory.products
                  .where(gtin: context.gtin)
                  .where(lot: context.lot)
                  .not_used
                  .first!

      if product.use!
        context.product = product
      else
        Rails.logger.debug "Using product failed: #{product.errors.full_messages}".red

        context.fail!(error: I18n.t('inventory.using_product_failed'))
      end
    end
  end
end
