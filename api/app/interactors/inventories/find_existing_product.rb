module Inventories
  class FindExistingProduct
    include Interactor

    def call
      product = context.product
      existing_product = context.current_inventory
                           .products
                           .find_by_datamatrix(product.datamatrix)

      if existing_product
        context.existing_product = existing_product
      end
    end
  end
end
