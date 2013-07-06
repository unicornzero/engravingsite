require 'test_helper'

class FlickrStreamControllerTest < ActionController::TestCase
  test "should get main_stream" do
    get :main_stream
    assert_response :success
  end

end
