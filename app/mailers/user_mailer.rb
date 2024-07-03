class UserMailer < ApplicationMailer
  default from: 'david.tamayo1112@gmail.com'

  def welcome_email(email)
    subject = 'Thank You for Reaching Out'
    body = "Dear Recruiter,\n\nThank you for reaching out. I have received your email and will review it shortly. Looking forward to the opportunity to discuss further.\n\nBest regards,\nDavid Tamayo"
    mail(to: email, subject: subject, body: body, content_type: 'text/plain')
  end

  def recruiter_email(name, email, message)
    body_recruiter = "This is the message:\n\n#{message}\n\nBest regards,\n#{name} #{email}"
    mail(to: 'david.tamayo1112@gmail.com', subject: 'Site Message', body: body_recruiter, content_type: 'text/plain')
  end
end
