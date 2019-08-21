module Orders
  class DeliverOrders
    include Interactor::Organizer

    organize FetchInventories,
             FetchRecipients,
             SendOrdersEmail,
             MarkOrdersAsDelivered
  end
end
