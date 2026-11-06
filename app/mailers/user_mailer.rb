class UserMailer < ApplicationMailer
  OWNER = 'david.tamayo1112@gmail.com'.freeze

  default from: OWNER

  # A message from the portfolio contact form, delivered only to the site owner.
  # Reply-To is the visitor, so answering the email goes straight to them.
  def contact_email(name, email, message)
    body = "New message from the portfolio contact form.\n\n" \
           "Name: #{name}\nEmail: #{email}\n\n#{message}\n"
    mail(to: OWNER, reply_to: email, subject: "Portfolio message from #{name.truncate(60)}",
         body: body, content_type: 'text/plain')
  end
end
