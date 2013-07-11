require 'test_helper'

class GoogleApiControllerTest < ActionController::TestCase
  test "should get youtube" do
    get :youtube
    assert_response :success
  end

end
