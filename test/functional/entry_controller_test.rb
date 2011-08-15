require 'test_helper'

class EntryControllerTest < ActionController::TestCase
  test "should get entry" do
    get :entry
    assert_response :success
  end

end
