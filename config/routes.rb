# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'report#index'

  scope 'report' do
    get '/:year', to: 'report#yearly', as: :report_yearly
    get '/:year/(:category)', to: 'report#category', as: :report_category
  end

  scope ':year' do
    get '/', to: 'report#index', as: :year
    get '/(:category)', to: 'report#index', as: :category
  end
end
