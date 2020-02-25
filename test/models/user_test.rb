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
    assert_difference ['@user_one.bits.count', '@user_one.ownerships.count'], -1 do
      @user_one.bits.first.destroy
    end
  end

  test "user has bits" do
    assert_equal 3, @user_one.bits.count
  end

  test "user delete bits" do
    assert_difference '@user_one.bits.count', -1 do
      bit = bits(:one)
      bit.destroy
    end
  end
end
