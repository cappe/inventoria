module Orders
  class SendOrdersEmail
    include Interactor

    def call
      attachment = {
        file_name: "tilaukset_#{Time.zone.now.strftime('%FT%R')}.xlsx",
        file: ExcelExports::ComposeProductOrders.compose_xlsx(context.inventories)
      }

      # Throw an exception if this fails. We don't want to
      # update order statuses if email delivery failed.
      UserMailer.send_orders(context.recipients_emails, attachment).deliver_now!
    end
  end
end
