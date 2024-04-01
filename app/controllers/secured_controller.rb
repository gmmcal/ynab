# frozen_string_literal: true

class SecuredController < ApplicationController
  before_action :authenticate

  protected

  def authenticate
    return if session[:authenticated]

    redirect_to new_auth_path
  end
end
