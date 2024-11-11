# frozen_string_literal: true

require "test_helper"

class ReportControllerTest < ActionDispatch::IntegrationTest
  test "should redirect to auth when client is unauthenticated" do
    get root_url
    assert_response :redirect
    assert_redirected_to new_auth_path
  end

  test "should show report when user is logged in" do
    post auths_url, params: { auth: { password: "password" } }

    get root_url
    assert_response :success
  end
end
