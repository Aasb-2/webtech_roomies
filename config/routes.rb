Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  resources :listings, only: [:index, :show]
  resources :properties, only: [:show]
end