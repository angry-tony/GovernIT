require 'test_helper'

class ConfigControllerTest < ActionController::TestCase
  test "should get riskmap" do
    get :riskmap
    assert_response :success
  end

end
