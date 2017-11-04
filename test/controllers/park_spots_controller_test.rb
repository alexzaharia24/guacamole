require 'test_helper'

class ParkSpotsControllerTest < ActionDispatch::IntegrationTest
  def admin_authenticated_header
    token = Knock::AuthToken.new(payload: {sub: users(:admin).id}).token
    {
      'Authorization': "Beared #{token}"
    }
  end

  def user_two_authenticated_header
    token = Knock::AuthToken.new(payload: {sub: users(:two).id}).token
    {
      'Authorization': "Beared #{token}"
    }
  end

  test "user should be able to create park spots" do
    post "/park_spot",
        headers: admin_authenticated_header,
        params: { park_spot: {name: "x" * 10, user_id: users(:two).id,
            address: "x" * 10, latitude: 1.5, longitude: 1.5,
            price_per_hour: 1.0,
            size: :medium, description: "x" * 50}}
    assert_response :success
  end

  test "admin should be able to delete park spots" do
    delete "/park_spot",
        headers: admin_authenticated_header,
        params: { id: "2" }
    assert_response :success
  end

  test "user should be able to delete it's own park spots" do
    delete '/park_spot',
      headers: user_two_authenticated_header,
      params: { id: "2" }
    assert_response :success
  end
end
