module Orders
  class FetchInventories
    include Interactor

    def call
      today = Time.zone.now.strftime('%A').downcase

      inventories = Inventory
                      .delivery_schedule_is(today)
                      .includes(orders: [:article])
                      .references(:orders)
                      .merge(context.with_status)

      if inventories.empty?
        context.fail!(error: 'No new orders found')
      else
        context.inventories = inventories
      end
    end
  end
end
