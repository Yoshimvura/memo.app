# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :users, only: %i[show index]

  devise_scope :user do
    root to: "devise/sessions#new"
  end

  resources :books do
    resources :comments
  end

  resources :reports do
    resources :comments
  end


  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :relationships, only: %i[create destroy]
end
