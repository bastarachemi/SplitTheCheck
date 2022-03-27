require "test_helper"

class RestaurantTest < ActiveSupport::TestCase
  setup do
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
end
