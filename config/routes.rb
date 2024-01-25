# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get "/users", to: "users#index"
  get "/users/:user_id", to: "users#show", as: "user"
  get "/users/:user_id/posts", to: "posts#index", as: "user_posts"
  get "/users/:user_id/posts/:post_id", to: "posts#show", as: "user_post"
end
