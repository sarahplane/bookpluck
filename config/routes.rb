Rails.application.routes.draw do

  get 'pages/home' => 'pages#home'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: 'devise/registrations' }

  namespace :notecards do
    resources :exports, only: [:index, :create]
    resources :uploads, only: [:index, :new, :create]
    resources :downloads, only: [:create]
  end

  resources :notecards do
    collection do
      get :report
    end
  end

  namespace :api do
    namespace :v1 do
      resources :notecards, only: [:index, :show, :create, :update, :destroy]
      resources :themes, only: [:index, :show]
    end
  end

  resources :themes, only:[:index, :show, :destroy]

  root 'pages#home'
end
