require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user_one = users(:one)
  end

  test "bits destroyed if user destroyed" do
    all_bits = Bit.count
    user_bits = @user_one.bits.count
    @user_one.destroy
    assert_equal (all_bits-user_bits), Bit.count
  end

  test "user destroy bits" do
    assert_equal 2, @user_one.bits.count
    assert_equal 2, @user_one.ownerships.count
    @user_one.bits.first.destroy
    assert_equal 1, @user_one.bits.count
    assert_equal 1, @user_one.ownerships.count
  end

  test "user has bits" do
    assert_equal 2, @user_one.bits.count
  end

  test "user delete bits" do
    assert_equal 2, @user_one.bits.count
    bit = bits(:one)
    bit.destroy
    assert_equal 1, @user_one.bits.count
  end
end
