require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "contact email keeps the visitor's text out of the headers" do
    mail = UserMailer.contact_email("Ada", "ada@example.com", "Line one\nLine two")
    assert_equal [UserMailer::OWNER], mail.to
    assert_equal ["ada@example.com"], mail.reply_to
    assert_equal "Portfolio message from Ada", mail.subject
    assert_includes mail.body.to_s, "Line one\nLine two"
  end
end
