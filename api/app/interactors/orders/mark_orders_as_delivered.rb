module Orders
  class MarkOrdersAsDelivered
    include Interactor

    def call
      context.inventories.each do |inventory|
        inventory.orders.each do |order|
          order.delivered!
        end
      end
    end
  end
end
