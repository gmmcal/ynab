# frozen_string_literal: true

require "test_helper"

class AuthsControllerTest < ActionDispatch::IntegrationTest
  test "valid password authenticates the user and redirects to the root page" do
    post auths_path, params: { auth: { password: "password" } }

    assert_redirected_to root_path
    assert_equal true, session[:authenticated]
  end

  test "uses the configured environment password when present" do
    original_password = ENV["APPLICATION_PASSWORD"]
    ENV["APPLICATION_PASSWORD"] = "super-secret"

    post auths_path, params: { auth: { password: "super-secret" } }

    assert_redirected_to root_path
    assert_equal true, session[:authenticated]
  ensure
    ENV["APPLICATION_PASSWORD"] = original_password
  end

  test "invalid password redirects back to the login page with a flash message" do
    post auths_path, params: { auth: { password: "wrong-password" } }

    assert_redirected_to new_auth_path
    assert_equal "Invalid password", flash[:danger]
    assert_nil session[:authenticated]
  end
end
