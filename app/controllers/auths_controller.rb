# frozen_string_literal: true

class AuthsController < ApplicationController
  def create
    if params[:auth][:password] == password
      session[:authenticated] = true
      redirect_to root_path
    else
      session[:authenticated] = nil
      redirect_to new_auth_path, flash: { danger: "Invalid password" }
    end
  end

  private

  def password
    ENV.fetch("APPLICATION_PASSWORD", "password")
  end
end
