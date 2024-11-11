# frozen_string_literal: true

require "test_helper"

class AuthsControllerTest < ActionDispatch::IntegrationTest
  test "should show authentication page" do
    get new_auth_url
    assert_response :success
  end

  test "should authenticate and redirect to root on success" do
    post auths_url, params: { auth: { password: "password" } }

    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should fail authentication on failure" do
    post auths_url, params: { auth: { password: "something else" } }

    assert_response :redirect
    assert_redirected_to new_auth_path
  end
end
