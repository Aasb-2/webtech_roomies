Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  patch "current_user", to: "current_users#update", as: :current_user

  resources :neighborhoods
  resources :amenities

  resources :properties do
    resources :listings, only: [:new, :create, :edit, :update, :destroy] do
      member do
        patch :publish
        patch :withdraw
        patch :mark_rented
      end
    end
    resources :reviews, only: [:create]
  end

  resources :listings, only: [:index, :show] do
    resource :application, only: [:create, :destroy], controller: "applications"
  end

  resources :applications, only: [:index, :update] do
    resource :visit, only: [:create, :update], controller: "visits"
  end
end