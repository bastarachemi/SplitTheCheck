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
end
