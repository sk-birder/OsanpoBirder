require "test_helper"

class Public::FollowsControllerTest < ActionDispatch::IntegrationTest
  test "should get following" do
    get public_follows_following_url
    assert_response :success
  end

  test "should get followers" do
    get public_follows_followers_url
    assert_response :success
  end
end
