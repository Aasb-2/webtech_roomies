Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :listings, only: [:index, :show]
    end
  end

  resource :session, only: [:new, :create, :destroy]
  resource :registration, only: [:new, :create]
  resource :profile, only: [:edit, :update]
  resources :passwords, param: :token, only: [:new, :create, :edit, :update]

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
    resources :reviews, only: [:create, :destroy]
  end

  resources :listings, only: [:index, :show] do
    resource :application, only: [:create, :destroy], controller: "applications"
    resources :reports, only: [:create]
  end

  resources :applications, only: [:index, :update] do
    resource :visit, only: [:create, :update], controller: "visits"
  end

  resources :reports, only: [:index, :update]

end