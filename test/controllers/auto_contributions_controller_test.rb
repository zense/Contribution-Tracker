require 'test_helper'

class AutoContributionsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get auto_contributions_create_url
    assert_response :success
  end

  test "should get new" do
    get auto_contributions_new_url
    assert_response :success
  end

  test "should get index" do
    get auto_contributions_index_url
    assert_response :success
  end

end
