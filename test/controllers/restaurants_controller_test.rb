require "test_helper"

class RestaurantsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @restaurant = restaurants(:one)
  end

  test "should get index" do
    get restaurants_url
    assert_response :success
    assert_select 'h1', 'Split The Check'
    assert_select 'tbody tr', 10
  end

  test "should get new if logged in" do
    sign_in @user
    get new_restaurant_url
    assert_response :success
  end

  test "should not get new if logged out" do
    get new_restaurant_url
    assert_redirected_to new_user_session_path
  end

  test "should create restaurant if logged in" do
    sign_in @user
    @restaurant.name = "Different Restaurant"
    assert_difference('Restaurant.count') do
      post restaurants_url, params: { restaurant: { city: @restaurant.city, name: @restaurant.name, state: @restaurant.state } }
    end

    assert_redirected_to restaurant_url(Restaurant.last)
  end

  test "should not create restaurant if logged out" do
    @restaurant.name = "Different Restaurant"
    assert_no_difference('Restaurant.count') do
      post restaurants_url, params: { restaurant: { city: @restaurant.city, name: @restaurant.name, state: @restaurant.state } }
    end

    assert_redirected_to new_user_session_path
  end

  test "should show restaurant" do
    get restaurant_url(@restaurant)
    assert_response :success
    assert_select 'h1', 'Split The Check'
    assert_select 'h2', 'Restaurant Details'
    assert_select '.btn', 3
  end

  test "should get edit if logged in" do
    sign_in @user
    get edit_restaurant_url(@restaurant)
    assert_response :success
    assert_select 'h1', 'Split The Check'
    assert_select 'h2', 'Editing Restaurant'
  end

  test "should not get edit if logged out" do
    get edit_restaurant_url(@restaurant)
    assert_redirected_to new_user_session_path
  end

  test "should update restaurant if logged in" do
    sign_in @user
    patch restaurant_url(@restaurant), params: { restaurant: { city: @restaurant.city, name: @restaurant.name, state: @restaurant.state } }
    assert_redirected_to restaurant_url(@restaurant)
  end

  test "should not update restaurant if logged out" do
    patch restaurant_url(@restaurant), params: { restaurant: { city: @restaurant.city, name: @restaurant.name, state: @restaurant.state } }
    assert_redirected_to new_user_session_path
  end

  test "cannot destroy restaurant" do
    assert_raises(ActionController::RoutingError) do
      delete restaurant_url(@restaurant)
    end
  end

  test "should properly navigate to next page of restaurants, up to the last page 6" do
    get restaurants_url
    assert_equal session[:page], 1
    assert_equal session[:last_page], 6

    1.upto(5) do |page|
      get restaurants_page_path(page)
      assert_response :redirect
      follow_redirect!
      assert_equal session[:page], page
      assert_select 'tbody tr', 10
    end

    get restaurants_page_path(6)
    assert_response :redirect
    follow_redirect!
    assert_equal session[:page], 6
    assert_select 'tbody tr', 2

    get restaurants_page_path(7)
    assert_response :redirect
    follow_redirect!
    assert_equal session[:page], 6
    assert_select 'tbody tr', 2

    get restaurants_page_path(1)
    assert_response :redirect
    follow_redirect!
    assert_equal session[:page], 1
    assert_select 'tbody tr', 10
  end

  test "should properly navigate to previous page of restaurants, down to page 1" do
    get restaurants_url
    assert_equal session[:page], 1
    assert_equal session[:last_page], 6

    get restaurants_page_path(6)
    assert_response :redirect
    follow_redirect!
    assert_equal session[:page], 6
    assert_select 'tbody tr', 2

    5.downto(1) do |page|
      get restaurants_page_path(page)
      assert_response :redirect
      follow_redirect!
      assert_equal session[:page], page
      assert_select 'tbody tr', 10
    end

    get restaurants_page_path(0)
    assert_response :redirect
    follow_redirect!
    assert_equal session[:page], 1
    assert_select 'tbody tr', 10

    get restaurants_page_path(6)
    assert_response :redirect
    follow_redirect!
    assert_equal session[:page], 6
    assert_select 'tbody tr', 2
  end

  test "should get restaurants that are searched for" do
    get restaurants_url(params: { restaurant_name: "Test Restaurant", restaurant_location: "Massachusetts" })
    assert_response :success
    assert_equal "Test Restaurant", session[:restaurant_name]
    assert_equal "Massachusetts", session[:restaurant_location]
    assert_equal 1, session[:page]
    assert_equal 5, session[:last_page]
    assert_select 'tbody tr', 10
  end

  test "should properly process upvotes if logged in" do
    sign_in @user
    get restaurant_url(@restaurant)
    assert_response :success
    assert_equal 1, @restaurant.will_split
    assert_equal 2, @restaurant.wont_split
    put upvote_restaurant_path(@restaurant)
    assert_redirected_to restaurant_url(@restaurant)
    @restaurant.reload
    assert_equal 2, @restaurant.will_split
    assert_equal 2, @restaurant.wont_split
    assert_equal "Restaurant was upvoted.", flash[:success]
  end

  test "should properly process downvotes if logged in" do
    sign_in @user
    get restaurant_url(@restaurant)
    assert_response :success
    assert_equal 1, @restaurant.will_split
    assert_equal 2, @restaurant.wont_split
    put downvote_restaurant_path(@restaurant)
    assert_redirected_to restaurant_url(@restaurant)
    @restaurant.reload
    assert_equal 1, @restaurant.will_split
    assert_equal 3, @restaurant.wont_split
    assert_equal "Restaurant was downvoted.", flash[:success]
  end

  test "should not vote if logged out" do
    get restaurant_url(@restaurant)
    assert_response :success
    assert_equal 1, @restaurant.will_split
    assert_equal 2, @restaurant.wont_split
    put upvote_restaurant_path(@restaurant)
    assert_redirected_to new_user_session_path

    get restaurant_url(@restaurant)
    assert_response :success
    assert_equal 1, @restaurant.will_split
    assert_equal 2, @restaurant.wont_split
    put downvote_restaurant_path(@restaurant)
    assert_redirected_to new_user_session_path
  end

  test "should favorite restaurant if logged in" do
    sign_in @user
    get restaurant_url(@restaurant)
    assert_response :success
    assert_equal 0, @restaurant.favorites.count
    put favorite_restaurant_path
    @restaurant.reload
    assert_equal 1, @restaurant.favorites.count
    assert @user.has_favorited?(@restaurant)
  end

  test "should unfavorite restaurant if logged in" do
    sign_in @user
    get restaurant_url(restaurants(:two))
    assert_response :success
    assert_equal 1, restaurants(:two).favorites.count
    put favorite_restaurant_path
    restaurants(:two).reload
    assert_equal 0, restaurants(:two).favorites.count
    assert_equal false, @user.has_favorited?(restaurants(:two))
  end

  test "should not favorite restaurant if logged out" do
    get restaurant_url(@restaurant)
    assert_response :success
    assert_equal 0, @restaurant.favorites.count
    put favorite_restaurant_path(@restaurant)
    assert_redirected_to new_user_session_path
    @restaurant.reload
    assert_equal 0, @restaurant.favorites.count
  end

end
