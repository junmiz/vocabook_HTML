require 'test_helper'

class ProblemsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get problems_show_url
    assert_response :success
  end

  test "should get destroy" do
    get problems_destroy_url
    assert_response :success
  end

  test "should get start" do
    get problems_start_url
    assert_response :success
  end

  test "should get answer" do
    get problems_answer_url
    assert_response :success
  end

end
