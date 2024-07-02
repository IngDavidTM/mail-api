require "test_helper"

class EmailsControllerTest < ActionDispatch::IntegrationTest
  test "should get send" do
    get emails_send_url
    assert_response :success
  end
end
