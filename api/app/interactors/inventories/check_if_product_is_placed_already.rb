module Inventories
  class CheckIfProductIsPlacedAlready
    include Interactor

    def call
      existing_product = context.existing_product

      # If we have an existing product that is not used, it's read
      # into the inventory but, suprisingly enough, not used.
      if existing_product && !existing_product.used?
        context.fail!(error: I18n.t('inventory.product_is_read_already'))
      end
    end
  end
end