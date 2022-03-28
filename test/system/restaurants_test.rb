require "application_system_test_case"

class RestaurantsTest < ApplicationSystemTestCase
  setup do
    @restaurant = restaurants(:one)
  end

  test "visiting the index" do
    visit restaurants_url
    assert_selector "h1", text: "Split The Check"
    assert_selector "th", text: "Name"
    assert_selector "th", text: "Location"
    assert_selector "th", text: "Will split"
    assert_selector "th", text: "Wont split"
  end

  test "creating a Restaurant" do
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

end
