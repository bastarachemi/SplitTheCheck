require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @restaurant = restaurants(:one)
  end

  test "creating a Comment" do
    sign_in @user
    visit restaurants_url
    click_on "Vote", match: :first
    click_on "Leave a Comment"

    fill_in "Message", with: "New Comment"
    click_on "Save Comment"

    assert_text "Comment was successfully created"
    click_on "Back to Home"

    visit user_profile_url
    assert_selector "td", text: "New Comment"
  end
end
