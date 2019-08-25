module Inventories
  class SaveProduct
    include Interactor

    def call
      product = context.product

      if product.save
        context.product = product
      else
        Rails.logger.debug "Saving product failed: #{product.errors.full_messages}".red

        context.fail!(error: I18n.t('inventory.add_to_inventory_failed'))
      end
    end
  end
end
