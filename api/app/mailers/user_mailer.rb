class UserMailer < ApplicationMailer
  def send_credentials_email(user)
    unless Rails.env.production?
      Rails.logger.debug "Does not send credentials email unless production...".red

      return
    end

    @user = user

    if user.admin?
      @role = 'admin-'
    else
      @role = 'asiakas'
    end

    mail to: user.email,
         subject: 'Kirjautumislinkki Inventoriaan'
  end

  def send_orders(recipients_emails, attachment)
    attachments[attachment[:file_name]] = attachment[:file]

    mail to: recipients_emails,
         subject: 'Tilaukset — Inventoria'
  end
end
