class UserMailer < ApplicationMailer
  default from: 'david.tamayo1112@gmail.com'

  def welcome_email(email, message)
    mail(to: email, subject: 'Welcome to My Awesome Site', body: message, content_type: 'text/plain')
  end
end
