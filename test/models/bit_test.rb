require 'test_helper'

class BitTest < ActiveSupport::TestCase
  setup do
    @four = bits(:four)
    @three = bits(:three)
  end

  test "invalid with early end_at" do
    bit = Bit.new(title: 'invalid', begin_at: DateTime.current, end_at: DateTime.current-1.day)
    refute bit.valid?, "bit with early end_at"
  end

  test "valid with end_at" do
    bit = Bit.new(title: 'valid', begin_at: DateTime.current, end_at: DateTime.current+1.day)
    assert bit.valid?, "bit with end_at"
  end

  test "invalid without end_at" do
    bit = Bit.new(title: 'invalid', begin_at: DateTime.current)
    refute bit.valid?, "bit without end_at"
  end

  test "invalid without title" do
    bit = Bit.new()
    refute bit.valid?, "bit without title"
  end

  test "valid with uri" do
    bit = Bit.new(uri: 'https://rubyonrails.org')
    assert bit.valid?, "bit with only uri"
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
