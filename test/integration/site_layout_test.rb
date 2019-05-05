require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
   test "layout links" do
    get root_path
    assert_template 'static_pages/home'
     ## Rails automatically inserts the value of path in place of the question mark 
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", explore_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path

    
  end


end
