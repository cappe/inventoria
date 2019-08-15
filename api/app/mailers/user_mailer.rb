class UserMailer < ApplicationMailer
  def send_credentials_email(user)
    @user = user

    mail to: user.email,
         subject: 'Kirjautumislinkki Inventoriaan'
  end
end
