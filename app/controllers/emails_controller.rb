class EmailsController < ApplicationController
  # Same limits as the contact form on the portfolio
  LIMITS = { name: 100, email: 254, message: 5000 }.freeze

  def send_email
    # Honeypot: the form hides this field from people. Bots that fill it get a
    # normal-looking success so they do not learn to skip it.
    return render json: { status: 'Email sent successfully' } if params[:website].present?

    contact = contact_params

    if contact.values.any?(&:blank?)
      return render json: { error: 'name, email and message are required' }, status: :unprocessable_entity
    end

    if LIMITS.any? { |field, max| contact[field].length > max }
      return render json: { error: 'one or more fields are too long' }, status: :unprocessable_entity
    end

    unless valid_email?(contact[:email])
      return render json: { error: 'email format is invalid' }, status: :unprocessable_entity
    end

    # Only the site owner receives mail. There is no auto-reply to the address
    # in the form: that would let anyone use this API to send mail to strangers.
    UserMailer.contact_email(contact[:name], contact[:email], contact[:message]).deliver_now

    render json: { status: 'Email sent successfully' }
  rescue StandardError => e
    Rails.logger.error("Failed to send email: #{e.class}")
    Sentry.capture_exception(e) if defined?(Sentry)
    render json: { error: 'Failed to send email' }, status: :internal_server_error
  end

  private

  def contact_params
    params.permit(:name, :email, :message).to_h.symbolize_keys.tap do |contact|
      # The name is a single line; the message keeps its line breaks
      contact[:name] = contact[:name].to_s.gsub(/[[:cntrl:]]/, ' ').squish
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
