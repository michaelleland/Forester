require 'test_helper'

class SetupControllerTest < ActionController::TestCase
  test "should get jobs" do
    get :jobs
    assert_response :success
  end

  test "should get owners" do
    get :owners
    assert_response :success
  end

  test "should get sawmills" do
    get :sawmills
    assert_response :success
  end

  test "should get loggers" do
    get :loggers
    assert_response :success
  end

end
