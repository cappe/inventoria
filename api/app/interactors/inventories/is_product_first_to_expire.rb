module Inventories
  class IsProductFirstToExpire
    include Interactor

    def call
      product = context.product
      inventory_id = product.inventory_id
      gtin = product.gtin

      product_first_to_expire = Product.first_to_expire(inventory_id, gtin)

      if product != product_first_to_expire
        formatted_expiry_date = product_first_to_expire.expiry_date.strftime('%d.%m.%Y')

        context.fail!(error: I18n.t('inventory.product_does_not_expire_first', date: formatted_expiry_date))
      end
    end
  end
end
