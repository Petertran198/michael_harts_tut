require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    # Get the path
    get signup_path
    #check that there is no difference in the number of user before and after, the assert_no_difference block ||
    assert_no_difference 'User.count' do
      # use the post method to submit INVALID test info to see that we have form validation
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    # check that it renders new if the form wasn't submitted, just like in the show method in user controller  
    assert_template 'users/new'
    # check to see if we have a way of displaying the error message
    assert_select 'div#error_explanation'

  end


  test "valid signup information" do
    #get the path
    get signup_path
    #check that there is a difference of 1 user before and after, the assert_difference block ||
    assert_difference 'User.count', 1 do
      # use the post method to submit VALID test info to see that we have form validation
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    #check that it redirects
    follow_redirect!
    #check that it brings up the users/show page
    assert_template 'users/show'
    # assert_not pass when it recieves a false, if flash.empty? returns true that means there is no flash msg
    assert_not flash.empty?
  end


end
