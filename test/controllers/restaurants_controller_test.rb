require "test_helper"

class RestaurantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @restaurant = restaurants(:one)
  end

  test "should get index" do
    get restaurants_url
    assert_response :success
    assert_select 'h1', 'Split The Check'
    assert_select 'tbody tr', 10
  end

  test "should get new" do
    get new_restaurant_url
    assert_response :success
  end

  test "should create restaurant" do
    @restaurant.name = "Different Restaurant"
    assert_difference('Restaurant.count') do
      post restaurants_url, params: { restaurant: { city: @restaurant.city, name: @restaurant.name, state: @restaurant.state, will_split: @restaurant.will_split, wont_split: @restaurant.wont_split } }
    end

    assert_redirected_to restaurant_url(Restaurant.last)
  end

  test "should show restaurant" do
    get restaurant_url(@restaurant)
    assert_response :success
    assert_select 'h1', 'Split The Check'
    assert_select 'h2', 'Restaurant Details'
    assert_select '.btn', 3
  end

  test "should get edit" do
    get edit_restaurant_url(@restaurant)
    assert_response :success
    assert_select 'h1', 'Split The Check'
    assert_select 'h2', 'Editing Restaurant'
  end

  test "should update restaurant" do
    patch restaurant_url(@restaurant), params: { restaurant: { city: @restaurant.city, name: @restaurant.name, state: @restaurant.state, will_split: @restaurant.will_split, wont_split: @restaurant.wont_split } }
    assert_redirected_to restaurant_url(@restaurant)
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
end
