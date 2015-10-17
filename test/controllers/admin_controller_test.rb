require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get file_users" do
    get :file_users
    assert_response :success
  end

end
