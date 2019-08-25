module Inventories
  class SetProduct
    include Interactor

    def call
      product = context.current_inventory
                  .products
                  .find_by(datamatrix: context.datamatrix)

      if product
        context.product = product
      else
        context.fail!(error: I18n.t('inventory.product_is_missing'))
      end
    end
  end
end
