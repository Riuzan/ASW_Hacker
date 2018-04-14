require 'test_helper'

class User33sControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user33 = user33s(:one)
  end

  test "should get index" do
    get user33s_url
    assert_response :success
  end

  test "should get new" do
    get new_user33_url
    assert_response :success
  end

  test "should create user33" do
    assert_difference('User33.count') do
      post user33s_url, params: { user33: { email: @user33.email, name: @user33.name } }
    end

    assert_redirected_to user33_url(User33.last)
  end

  test "should show user33" do
    get user33_url(@user33)
    assert_response :success
  end

  test "should get edit" do
    get edit_user33_url(@user33)
    assert_response :success
  end

  test "should update user33" do
    patch user33_url(@user33), params: { user33: { email: @user33.email, name: @user33.name } }
    assert_redirected_to user33_url(@user33)
  end

  test "should destroy user33" do
    assert_difference('User33.count', -1) do
      delete user33_url(@user33)
    end

    assert_redirected_to user33s_url
  end
end
