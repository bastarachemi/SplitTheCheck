require "test_helper"

class RestaurantTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @restaurant = restaurants(:one)
  end

  test "restaurant attributes must not be empty" do
    restaurant = Restaurant.new
    assert restaurant.invalid?
    assert restaurant.errors[:name].any?
    assert restaurant.errors[:city].any?
    assert restaurant.errors[:state].any?
  end

  test "restaurant is not valid for non-unique name in a city and state" do
    restaurant = Restaurant.new(
                            name: @restaurant.name,
                            city: "Boston",
                            state:  "Massachusetts"
                          )
    assert restaurant.invalid?
    assert_equal ["has already been taken"], restaurant.errors[:name]
  end

  test "search returns a single restaurant" do
    restaurant = Restaurant.search(@restaurant.name, @restaurant.city)
    assert_equal 1, restaurant.count
  end

  test "search returns multiple restaurants" do
    restaurant = Restaurant.search("Test Restaurant", "Boston, Massachusetts")
    assert restaurant.count > 1
  end

  test "search returns no restaurants" do
    restaurant = Restaurant.search("Unknown Restaurant", "Atlanta, Georgia")
    assert_equal 0, restaurant.count
  end

  test "search returns all restaurants if no search parameters specified" do
    restaurant = Restaurant.search("", "")
    assert_equal 52, restaurant.count
  end

  test "search finds restaurants by exact name without location" do
    restaurant = Restaurant.search(@restaurant.name, "")
    assert_equal 2, restaurant.count
    assert_equal "Boston Eatery", restaurant.first.name
  end

  test "search finds restaurants by exact name and city" do
    restaurant = Restaurant.search(@restaurant.name, @restaurant.city)
    assert_equal 1, restaurant.count
    assert_equal "Boston Eatery", restaurant.first.name
    assert_equal "Boston", restaurant.first.city
  end

  test "search finds restaurants by exact name and state" do
    restaurant = Restaurant.search(@restaurant.name, @restaurant.state)
    assert_equal 1, restaurant.count
    assert_equal "Boston Eatery", restaurant.first.name
    assert_equal "Massachusetts", restaurant.first.state
  end

  test "search finds restaurant by exact name and city and state" do
    location = @restaurant.city + ", " + @restaurant.state
    restaurant = Restaurant.search(@restaurant.name, location)
    assert_equal 1, restaurant.count
    assert_equal "Boston Eatery", restaurant.first.name
    assert_equal "Boston", restaurant.first.city
    assert_equal "Massachusetts", restaurant.first.state
  end

  test "search finds restaurants by city only" do
    restaurant = Restaurant.search("", @restaurant.city)
    assert_equal 51, restaurant.count
  end

  test "search finds restaurants by state only" do
    restaurant = Restaurant.search("", @restaurant.state)
    assert_equal 51, restaurant.count
  end

  test "search finds restaurants by city and state only" do
    location = @restaurant.city + ", " + @restaurant.state
    restaurant = Restaurant.search("", location)
    assert_equal 51, restaurant.count
  end

  test "search finds restaurants by partial name" do
    restaurant = Restaurant.search("Test", "")
    assert_equal 50, restaurant.count
  end

  test "will_split counts the number of will_split votes for the restaurant" do
    assert_equal 1, @restaurant.will_split
    assert_equal 1, restaurants(:two).will_split
  end

  test "wont_split counts the number of wont_split votes for the restaurant" do
    assert_equal 2, @restaurant.wont_split
    assert_equal 0, restaurants(:two).wont_split
  end
end
