require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def admin_authenticated_header
    token = Knock::AuthToken.new(payload: {sub: users(:admin).id}).token
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

  test "should authenticate user successfully" do
    get "/auth", headers: admin_authenticated_header
    assert_response :success
  end

  test "should successfully create, login and get users" do
    post "/user",
        params: { user: {email: "user1@example.com", password: "user1password"}}
    assert_response :success
    post "/login",
        params: { auth: {email: "user1@example.com", password: "user1password"}}
    assert_response :success
    token = JSON.parse(response.body)["jwt"]
    get "/user",
        headers: {'Authorization': token}
    assert_response :success
    user = JSON.parse(response.body)
    assert_equal "user1@example.com", user["email"]
  end

  test "should successfully update user" do
    post "/user",
        params: { user: {email: "user1@example.com", password: "user1password"}}
    assert_response :success
    post "/login",
        params: { auth: {email: "user1@example.com", password: "user1password"}}
    assert_response :success
    token = JSON.parse(response.body)["jwt"]
    get "/user",
        headers: {'Authorization': token}
    assert_response :success
    user = JSON.parse(response.body)
    user_id_initial = user['id']
    patch "/user/#{user['id']}",
        headers: {'Authorization': token},
        params: { user: {email: "user11@example.com"}}
    assert_response :success
    get "/user",
        headers: {'Authorization': token}
    assert_response :success
    user = JSON.parse(response.body)
    assert_equal "user11@example.com", user["email"]
    assert_equal "user", user["role"]
    assert_equal user_id_initial, user["id"]
  end

  test "should not let the user login with bad credentials" do
    post "/user",
        params: { user: {email: "user1@example.com", password: "user1password"}}
    assert_response :success
    post "/login",
        params: { auth: {email: "user1@example.com", password: "password1user"}}
    assert_response :not_found
  end

  test "not logged admin cannot delete user" do
    delete "/user/2"
    assert_response :unauthorized
    assert false
  end

  test "logged admin can delete user" do
    delete "/user/2",
        headers: admin_authenticated_header
    assert_response :success
  end

  test "should get current user" do
    post "/user",
      params: { user: {email: "user1@example.com", password: "user1password"}}
  end

  test "should not create users when already exists" do
    post "/user",
        params: { user: {email: "admin@example.com", password: "user1password"}}
    assert_response :bad_request
  end
end
