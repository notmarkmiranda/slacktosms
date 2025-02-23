Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "up" => "rails/health#show", as: :rails_health_check

  root "marketing#home"

  get "dashboard" => "dashboard#show", as: :dashboard

  get "login" => "sessions#new", as: :new_user_session
  post "login" => "sessions#create"
  get "verify/:token" => "sessions#verify", as: :verify_token
  post "verify/:id" => "sessions#verify_user", as: :verify_user
  delete "logout" => "sessions#destroy"

  get "slack/oauth/callback" => "oauth#callback"
end
