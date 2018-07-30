require 'test_helper'

class VocabookControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get vocabook_show_url
    assert_response :success
  end

  test "should get update" do
    get vocabook_update_url
    assert_response :success
  end

end
