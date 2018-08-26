require 'test_helper'

class WellcomControllerTest < ActionDispatch::IntegrationTest
  test "should get wellcom" do
    get wellcom_wellcom_url
    assert_response :success
  end

end
