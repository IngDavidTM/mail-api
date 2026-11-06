require "test_helper"

class EmailsControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper

  setup { Rack::Attack.cache.store.clear }

  def post_contact(overrides = {})
    payload = { name: "Ada", email: "ada@example.com", message: "Hello" }.merge(overrides)
    post "/send_email", params: payload, as: :json
  end

  test "sends one email to the owner, with the visitor as reply-to" do
    assert_emails(1) { post_contact }
    assert_response :success

    mail = ActionMailer::Base.deliveries.last
    assert_equal [UserMailer::OWNER], mail.to
    assert_equal ["ada@example.com"], mail.reply_to
  end

  test "never sends mail to the address typed in the form" do
    post_contact(email: "stranger@example.com")
    recipients = ActionMailer::Base.deliveries.flat_map(&:to)
    assert_not_includes recipients, "stranger@example.com"
  end

  test "honeypot submissions look successful but send nothing" do
    assert_no_emails { post_contact(website: "http://spam.example") }
    assert_response :success
  end

  test "rejects missing fields" do
    assert_no_emails { post_contact(message: "  ") }
    assert_response :unprocessable_entity
  end

  test "rejects an invalid email" do
    assert_no_emails { post_contact(email: "not-an-email") }
    assert_response :unprocessable_entity
  end

  test "rejects fields over the limit" do
    assert_no_emails { post_contact(message: "a" * 5001) }
    assert_response :unprocessable_entity
  end

  test "rejects header injection in the email field" do
    assert_no_emails { post_contact(email: "ada@example.com\r\nBcc: victim@example.com") }
    assert_response :unprocessable_entity
  end

  test "throttles bursts from one address" do
    6.times { post_contact }
    assert_response :too_many_requests
  end
end
