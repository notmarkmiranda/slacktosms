Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "up" => "rails/health#show", as: :rails_health_check

  mount GoodJob::Engine => "good_job"

  root "marketing#home"
  get "consent" => "marketing#consent", as: :consent
  get "privacy" => "marketing#privacy", as: :privacy

  get "dashboard" => "dashboard#show", as: :dashboard

  get "login" => "sessions#new", as: :new_user_session
  post "login" => "sessions#create"
  get "verify/:token" => "sessions#verify", as: :verify_token
  post "verify/:id" => "sessions#verify_user", as: :verify_user
  delete "logout" => "sessions#destroy"

  get "slack/oauth/callback" => "oauth#callback"

  resources :slack_connections, only: [ :show ] do
    post :create_subscriptions, on: :member
  end
end
