require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end


  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    ## set @user.name to a BLANK string
    # It does this to make sure we created a validation in the user model 
    @user.name = " "
    #assert_not checks if the follow returns false, if it does, it pass the test
    assert_not @user.valid?
  end

  test "email should be present" do
    ## set @user.email to a BLANK string
    # It does this to make sure we created a validation in the user model 
    @user.email = "  "
    #assert_not checks if the follow returns false, if it does, it pass the test
    assert_not @user.valid?
  end

  test "name should not be too long" do
    ## set @user.name to 51 char 
    # It does this to make sure we created a length validation of 50 in the user model 
    @user.name = "a" * 51
    #assert_not checks if the follow returns false, if it does, it pass the test
    ## assert_not will return false because in the model we set it to a maximum of 50
    ## because it is false it will pass the test 
    assert_not @user.valid?
  end

  test "email should not be too long" do 
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
     # %w[] is a way of creating an array of strings, whitespace seperates the values
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
       #checks if it is valid, and provide a optional second arugment that identifies the address that cause the fail
       # note if assert_not gets pass a true it will fail. Assert_not only pass if gets a false or nil
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    #To check for uniqueness u have to save to database
    # dup creates a duplicate user with the same attribute
    #Therefore, since the setup method uses User.new the duplicate user has an email address that already exists in the database, and hence should not be valid.
    duplicate_user = @user.dup
    # To make sure the email is case INsenitive 
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end


end
