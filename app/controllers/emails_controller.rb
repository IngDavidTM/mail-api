class EmailsController < ApplicationController
  def send_email
    name = params[:name]
    email = params[:email]
    message = params[:message]

    UserMailer.welcome_email(email).deliver_now
    UserMailer.recruiter_email(name, email, message).deliver_now

    render json: { status: 'Email sent successfully' }
  end
end
