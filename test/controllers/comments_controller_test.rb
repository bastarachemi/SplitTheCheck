require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @comment = comments(:one)
    @user = users(:one)
    @restaurant = restaurants(:one)
  end

  test "should get new if logged in" do
    sign_in @user
    get new_restaurant_comment_path(@restaurant)
    assert_response :success
  end

  test "should not get new if logged out" do
    get new_restaurant_comment_path(@restaurant)
    assert_redirected_to new_user_session_path
  end

  test "should create comment if logged in" do
    sign_in @user
    get restaurant_url(@restaurant)
    assert_difference('@restaurant.comments.count') do
      post restaurant_comments_url(@restaurant), params: { comment: { message: @comment.message, restaurant_id: @comment.restaurant_id, user_id: @comment.user_id } }
    end

    assert_redirected_to restaurant_url(@restaurant)
  end

  test "should not create comment if logged out" do
    get restaurant_url(@restaurant)
    assert_no_difference('@restaurant.comments.count') do
      post restaurant_comments_url(@restaurant), params: { comment: { message: @comment.message, restaurant_id: @comment.restaurant_id, user_id: @comment.user_id } }
    end

    assert_redirected_to new_user_session_path
  end

end
