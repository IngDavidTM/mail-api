class EmailsController < ApplicationController
  def send_email
    contact = contact_params

    if contact.values.any?(&:blank?)
      return render json: { error: 'name, email and message are required' }, status: :unprocessable_entity
    end

    unless valid_email?(contact[:email])
      return render json: { error: 'email format is invalid' }, status: :unprocessable_entity
    end

    UserMailer.welcome_email(contact[:email]).deliver_now
    UserMailer.recruiter_email(contact[:name], contact[:email], contact[:message]).deliver_now

    render json: { status: 'Email sent successfully' }
  rescue StandardError => e
    Rails.logger.error("Failed to send email: #{e.class} - #{e.message}")
    Sentry.capture_exception(e) if defined?(Sentry)
    render json: { error: 'Failed to send email' }, status: :internal_server_error
  end

  private

  def contact_params
    params.permit(:name, :email, :message).to_h.symbolize_keys.tap do |contact|
      contact[:name] = contact[:name].to_s.strip
      contact[:email] = contact[:email].to_s.strip
      contact[:message] = contact[:message].to_s.strip
    end
  end

  def valid_email?(email)
    email.match?(URI::MailTo::EMAIL_REGEXP)
  rescue StandardError
    false
  end
end
