require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  test "should get user summary page if logged in" do
    sign_in @user
    get user_profile_url
    assert_response :success
  end

  test "should not get user summary page if logged out" do
    get user_profile_url
    assert_redirected_to new_user_session_path
  end
end
