require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  test "should get owner_receipt" do
    get :owner_receipt
    assert_response :success
  end

  test "should get logger_receipt" do
    get :logger_receipt
    assert_response :success
  end

end
