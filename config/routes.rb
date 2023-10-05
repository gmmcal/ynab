# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'report#index'

  get '/:year', to: 'report#index', as: :year
  get '/:year/(:category)', to: 'report#index', as: :category
end
