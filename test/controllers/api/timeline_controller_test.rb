require 'test_helper'

class Api::TimelineControllerTest < ActionController::TestCase
  test "should get interval" do
    get :interval
    assert_response :success
  end

end
