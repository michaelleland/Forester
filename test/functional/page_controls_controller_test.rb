require 'test_helper'

class PageControlsControllerTest < ActionController::TestCase
  test "should get add_specie" do
    get :add_specie
    assert_response :success
  end

end
