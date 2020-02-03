require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @bit = bits(:one)
    sign_in @user
  end

  test "should get profile" do
    get profile_user_url
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url
    assert_response :success
  end

  test "should get update" do
    get user_url
    assert_response :success
  end

end
