require "test_helper"

class UserTest < ActiveSupport::TestCase

  setup do
    @user = users(:one)
    @restaurant = restaurants(:one)
  end

  test "user attributes cannot be empty" do
    user = User.new
    assert user.invalid?
    assert user.errors[:email].any?
    assert user.errors[:password].any?
  end

  test "user is not valid without proper email address" do
    assert @user.valid?
    assert @user.errors[:email].empty?

    @user.email = "invalidemail"
    assert @user.invalid?
    assert @user.errors[:email].any?

    @user.email = "invalidemail.com"
    assert @user.invalid?
    assert @user.errors[:email].any?
  end

  test "user is not valid without a unique email" do
    user = User.new(email: @user.email,
                    password: 123456)
    assert user.invalid?
    assert_equal ["has already been taken"], user.errors[:email]
  end

  test "user is not valid without minimum password characters" do
    user = User.new(email: "new@email.com",
                    password: 12345)
    assert user.invalid?
    assert_equal ["is too short (minimum is 6 characters)"], user.errors[:password]
  end

  test "should vote for a restaurant to split the check or not" do
    assert_equal 3, @user.votes.size
    @user.vote(@restaurant, true)
    assert_equal 4, @user.votes.size
    @user.vote(@restaurant, true)
    @user.vote(@restaurant, false)
    assert_equal 6, @user.votes.size
  end

end
