module Inventories
  class BuildProduct
    include Interactor

    def call
      product = context
                  .current_inventory
                  .products
                  .build(context.product_params)
      product.article = context.article

      context.product = product
    end
  end
end
