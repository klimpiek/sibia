require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @bit = bits(:one)
    sign_in @user
  end

  test "should not get workspace without sign in" do
    sign_out @user

    get workspace_url
    assert_response :redirect
  end

  test "should get workspce" do
    get workspace_url
    assert_response :success
  end

  test "should get home without sign in" do
    sign_out @user

    get root_url
    assert_response :success
  end

  test "should get home" do
    get root_url
    assert_response :success
  end

end
