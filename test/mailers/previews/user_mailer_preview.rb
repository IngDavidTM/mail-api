# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def contact_email
    UserMailer.contact_email("Ada Lovelace", "ada@example.com", "Hi David, I'd like to talk about a project.")
  end
end
