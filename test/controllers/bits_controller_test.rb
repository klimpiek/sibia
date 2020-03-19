require 'test_helper'

class BitsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
 
  setup do
    @user = users(:one)
    @bit = bits(:one)
    sign_in @user
  end

  test "should get index" do
    get bits_url
    assert_response :success
  end

  test "should get new" do
    get new_bit_url
    assert_response :success
  end

  test "should not create bit with invalid being and end date" do
    assert_difference('Bit.count', 0) do
      post bits_url, params: { bit: { content: @bit.content, description: @bit.description, title: @bit.title, begin_at: DateTime.current, end_at: DateTime.current-1.day } }
    end
  end

  test "should create bit" do
    assert_difference('Bit.count') do
      post bits_url, params: { bit: { content: @bit.content, description: @bit.description, title: @bit.title } }
    end

    assert_redirected_to bit_url(Bit.last)
  end

  test "should show bit" do
    get bit_url(@bit)
    assert_response :success
  end

  test "should get edit" do
    get edit_bit_url(@bit)
    assert_response :success
  end

  test "should update bit" do
    patch bit_url(@bit), params: { bit: { content: @bit.content, description: @bit.description, title: @bit.title } }
    assert_redirected_to bit_url(@bit)
  end

  test "should destroy bit" do
    assert_difference('Bit.count', -1) do
      delete bit_url(@bit)
    end

    assert_redirected_to bits_url
  end
end
