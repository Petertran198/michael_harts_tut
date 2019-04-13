require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    #both in test/user.yml
    @user       = users(:michael)
    @other_user = users(:archer)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when logged in as another user" do
    #log in as user
    log_in_as(@other_user)
    #try to access other_user
    get edit_user_path(@user)
    #Check that flash is empty
    assert flash.empty?
    #check that it redirects to ur root path
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as another user" do
    log_in_as(@other_user)
    patch user_path(@user), params: {user: { name: @user.name,
                                                    email: @user.email }}
    assert flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end




end
