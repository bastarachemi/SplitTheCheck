require "application_system_test_case"

class RestaurantsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @restaurant = restaurants(:one)
  end

  test "visiting the index" do
    visit restaurants_url
    assert_selector "h1", text: "Split The Check"
    assert_selector "th", text: "Name"
    assert_selector "th", text: "Location"
    assert_selector "th", text: "Will Split"
    assert_selector "th", text: "Won't Split"
  end

  test "creating a Restaurant" do
    sign_in @user
    visit restaurants_url
    click_on "Add New Restaurant"
    assert_selector "h2", text: "Adding New Restaurant"

    fill_in "City", with: @restaurant.city
    fill_in "Name", with: "New Restaurant"
    fill_in "State", with: @restaurant.state
    click_on "Create Restaurant"

    assert_text "Restaurant was successfully created"
    click_on "Back to Home"
  end

  test "updating a Restaurant" do
    sign_in @user
    visit restaurants_url
    click_on "Vote", match: :first
    click_on "Edit Restaurant"

    fill_in "City", with: "New Restaurant"
    fill_in "Name", with: @restaurant.name
    fill_in "State", with: @restaurant.state
    click_on "Update Restaurant"

    assert_text "Restaurant was successfully updated."
    click_on "Back to Home"
  end

  test "searching for a Restaurant" do
    visit restaurants_url
    fill_in "Restaurant Name", with: @restaurant.name
    click_on "Search"
    assert_selector "td", text: @restaurant.name
    assert_selector "td", text: @restaurant.city + ", " + @restaurant.state

    fill_in "Restaurant Name", with: ""
    fill_in "Restaurant Location", with: @restaurant.city
    click_on "Search"
    assert_selector "td", text: @restaurant.name
    assert_selector "td", text: @restaurant.city + ", " + @restaurant.state


    fill_in "Restaurant Name", with: @restaurant.name
    fill_in "Restaurant Location", with: @restaurant.state
    click_on "Search"
    assert_selector "td", text: @restaurant.name
    assert_selector "td", text: @restaurant.city + ", " + @restaurant.state
  end

  test "voting for a Restaurant" do
    sign_in @user
    @new_restaurant = restaurants(:fix_2)

    visit restaurant_url(@new_restaurant)
    click_on "Will Split"
    assert_text "Restaurant was upvoted."

    visit user_profile_url
    assert_selector "td", text: @new_restaurant.name

    visit restaurant_url(@new_restaurant)
    click_on "Won't Split"
    assert_text "Restaurant was downvoted."
  end

  test "favoriting a Restaurant" do
    sign_in @user
    @new_restaurant = restaurants(:fix_2)

    visit restaurant_url(@new_restaurant)
    assert_selector "svg", count: 0
    click_on "Favorite Restaurant"
    assert_selector "svg", count: 1
    visit user_profile_url
    assert_selector "td", text: @new_restaurant.name

    visit restaurant_url(@new_restaurant)
    click_on "Unfavorite Restaurant"
    assert_no_selector "svg"

    visit user_profile_url
    assert_no_selector "td", text: @new_restaurant.name
  end

end
