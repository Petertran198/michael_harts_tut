require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    #Visit the login path.
    get login_path
    #Verify that the new sessions form renders properly.
    assert_template 'sessions/new'
    #Post to the sessions path with an invalid params hash.
    post login_path, params: { session: {email: "", password: ""} }
    #Verify that the new sessions form gets re-rendered and that a flash message appears.
    assert_template 'sessions/new'
    assert_not flash.empty?
    #Visit another page (such as the Home page).
    get root_path
    #Verify that the flash message doesn’t appear on the new page.
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
   # Visit the login path.
    get login_path
    #Post valid information to the sessions path.
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    #make sure a session is starting                                       
    assert is_logged_in?                                 
    #make sure we get redirected and follow through                                      
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    #Verify that the login link disappears.                                      
    assert_select "a[href=?]", login_path, count: 0
    #Verify that a logout link appears
    assert_select "a[href=?]", logout_path
    #Verify that a profile link appears.
    assert_select "a[href=?]", user_path(@user)
    #log out
    delete logout_path
    #make sure the session ended 
    assert_not is_logged_in?
    #make sure it redirects to root path
    assert_redirected_to root_path
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    #make sure the login link is showing
    assert_select "a[href=?]", login_path
    #make sure the logout link is not showing
    assert_select "a[href=?]", logout_path,      count: 0
    #make sure profile link is not showing
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies[:remember_token]
  end

  test "login without remembering" do
    # Log in to set the cookie.
    log_in_as(@user, remember_me: '1')
    # Log in again and verify that the cookie is deleted.
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end 

end
