module Inventories
  class AddToInventory
    include Interactor

    def call
      product = context.current_inventory.products.build(context.product_params)
      product.article = context.article

      if product.save
        context.product = product
      else
        Rails.logger.debug "Saving product failed: #{product.errors.full_messages}".red

        context.fail!(error: I18n.t('inventory.add_to_inventory_failed'))
      end
    end
  end
end