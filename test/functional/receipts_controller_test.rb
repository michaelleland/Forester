require 'test_helper'

class ReceiptsControllerTest < ActionController::TestCase
  test "should get owner_receipt" do
    get :owner_receipt
    assert_response :success
  end

  test "should get logger_receipt" do
    get :logger_receipt
    assert_response :success
  end

  test "should get trucker_receipt" do
    get :trucker_receipt
    assert_response :success
  end

end
