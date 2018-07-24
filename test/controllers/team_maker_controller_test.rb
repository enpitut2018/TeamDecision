require 'test_helper'

class TeamMakerControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get team_maker_home_url
    assert_response :success
  end

  test "should get make" do
    get team_maker_make_url
    assert_response :success
  end

  test "should get join" do
    get team_maker_join_url
    assert_response :success
  end

  test "should get result" do
    get team_maker_result_url
    assert_response :success
  end

end
