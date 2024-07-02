class EmailsController < ApplicationController
  def send_email
    email = params[:email]
    message = params[:message]

    UserMailer.welcome_email(email, message).deliver_now

    render json: { status: 'Email sent successfully' }
  end
end
