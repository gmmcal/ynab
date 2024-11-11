# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "report#index"

  resources :auths, only: %i[new create]

  scope "report" do
    get "/", to: "report#all"
    get "/(:year)", to: "report#yearly", constraints: { year: /\d*/ }
    get "/(:category)", to: "report#category"
    get "/(:year)/(:category)", to: "report#category", as: :report, constraints: { year: /\d*/ }
  end

  scope "" do
    get "/", to: "report#index"
    get "/(:year/)(:category)", to: "report#index", as: :category_year, constraints: { year: /\d*/ }
    get "/(:year)", to: "report#index", as: :year, constraints: { year: /\d*/ }
    get "/(:category)", to: "report#index", as: :category
  end
end
