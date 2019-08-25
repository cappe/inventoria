module Inventories
  class CheckIfProductIsUsed
    include Interactor

    # Checks if product is used.
    #
    # NOTE!
    #
    # Expects existing product or
    # product to be set in the context.
    def call
      product = context.existing_product || context.product

      if product.used?
        context.fail!(error: I18n.t('inventory.product_is_used_already'))
      end
    end
  end
end
