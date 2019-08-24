module Orders
  class FetchInventories
    include Interactor

    def call
      inventories = Inventory
                      .includes(orders: [:article])
                      .references(:orders)
                      .merge(orders_with_status)

      if context.with_status != :deliver_now
        today = Time.zone.now.strftime('%A').downcase

        inventories = inventories.delivery_schedule_is(today)
      end

      if inventories.empty?
        context.fail!(error: 'No new orders found')
      else
        context.inventories = inventories
      end
    end

    private

      def orders_with_status
        if context.with_status === :deliver_now
          Order.status_is_deliver_now
        elsif context.with_status == :pending
          Order.status_is_pending
        else
          raise 'order status not set'
        end
      end
  end
end
