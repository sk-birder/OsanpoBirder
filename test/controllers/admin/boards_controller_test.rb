require "test_helper"

class Admin::BoardsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_boards_new_url
    assert_response :success
  end

  test "should get index" do
    get admin_boards_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_boards_show_url
    assert_response :success
  end
end
