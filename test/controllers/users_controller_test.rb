require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def authenticated_header
    token = Knock::AuthToken.new(payload: {sub: users(:one).id}).token
    {
      'Authorization': "Beared #{token}"
    }
  end

  test "should get index" do
    get "/"
    assert_response :success
  end

  test "can't access auth without login" do
    get "/auth"
    assert_response :unauthorized
  end

  test "should respons successfully" do
    get "/auth", headers: authenticated_header
    assert_response :success
  end
end
