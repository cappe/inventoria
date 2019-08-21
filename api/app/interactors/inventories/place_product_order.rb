module Inventories
  class PlaceProductOrder
    include Interactor

    def call
      params = {
        article_id: context.product.article_id,
        product_id: context.product.id,
        user_id: context.current_user.id
      }

      order = context.current_inventory.orders.build(params)

      if order.save
        context.order = order
      else
        Rails.logger.debug "Placing product order failed: #{order.errors.full_messages}".red

        context.fail!(error: I18n.t('inventory.placing_product_order_failed'))
      end
    end

    def rollback
      context.order.destroy
    end
  end
end
