require 'test_helper'

class BitTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @bit = bits(:one)
  end

  test "Bit has no tags" do
    assert @bit.tags(user: @user).blank?
  end                                                                                                         

  test "Bit can set tags" do
    ownership = Ownership.find_by(user: @user, bit: @bit)
    ownership.tags = ['summer']
    ownership.save!
    assert @bit.tags(user: @user).include?('summer')
  end                                                                                                         

  test "Bit can add tags" do
    ownership = Ownership.find_by(user: @user, bit: @bit)
    ownership.tags = ['summer']
    ownership.save!
    ownership.tags << 'swim'
    ownership.save!
    assert @bit.tags(user: @user).include?('swim')
  end                                                                                                         

  test "Bit can delete tags" do
    ownership = Ownership.find_by(user: @user, bit: @bit)
    ownership.tags = ['summer', 'swim']
    ownership.save!
    assert @bit.tags(user: @user).include?('swim')
    ownership.tags.delete 'swim'
    ownership.tags_will_change!
    ownership.save!
    assert_not @bit.tags(user: @user).include?('swim')
  end                                                                                                         

  test "Find bit with tag" do
    ownership = Ownership.find_by(user: @user, bit: @bit)
    ownership.update_attribute(:tags, ['summer', 'swim'])
    assert @bit.tags(user: @user).include?('swim')
    assert_equal @bit, @user.bits.with_any_tag('summer').first
  end                                                                                                         

  test "Find bit with any tag" do
    user_two = users(:two)
    bit_two = bits(:two)
    user_two.bits << bit_two
    Ownership.find_by(user: @user, bit: @bit).update_attribute(:tags, ['summer', 'swim'])
    Ownership.find_by(user: user_two, bit: bit_two).update_attribute(:tags, ['winter', 'swim'])
    assert_equal 1, @user.bits.with_any_tag('summer, winter, spring, fall').count
    assert_equal 2, Bit.joins(:ownerships).with_any_tag('summer, winter, spring, fall').count
  end                                                                                                         

  test "Find bit with all tags" do
    Ownership.find_by(user: @user, bit: @bit).update_attribute(:tags, ['summer', 'swim'])
    assert @user.bits.with_all_tags('summer, winter, spring, fall').blank?
    assert_equal 1, @user.bits.with_all_tags('summer, swim').count
  end                                                                                                         
end
