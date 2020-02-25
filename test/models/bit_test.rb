require 'test_helper'

class BitTest < ActiveSupport::TestCase
  setup do
    @four = bits(:four)
    @three = bits(:three)
  end

  test "bits has predecessor" do
    assert_equal @three, @four.predecessor
  end

  test "delete bits with predecessor association" do
    assert_difference 'Bit.count', -1 do
      @three.destroy
    end
  end
end
