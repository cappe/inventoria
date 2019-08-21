module Orders
  class FetchRecipients
    include Interactor

    def call
      recipients_emails = User
                            .admins_who_receive_orders
                            .map(&:email)

      if recipients_emails.empty?
        context.fail!(error: 'Recipients not found')
      else
        context.recipients_emails = recipients_emails
      end
    end
  end
end
