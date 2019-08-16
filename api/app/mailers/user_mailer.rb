class UserMailer < ApplicationMailer
  def send_credentials_email(user)
    @user = user

    if user.admin?
      @role = 'admin-'
    else
      @role = 'asiakas'
    end

    mail to: user.email,
         subject: 'Kirjautumislinkki Inventoriaan'
  end
end
