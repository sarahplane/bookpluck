Rails.application.routes.draw do

  get 'pages/home' => 'pages#home'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: 'registrations' }

  resources :notecards do
    get :download

    collection do
      get :report
      post :upload
      get :uploader
      get :upload_approval
    end
  end

  namespace :api do
    namespace :v1 do
      resources :notecards, only: [:index, :show]
    end
  end

  resources :themes, only:[:index, :show, :destroy]

  root 'pages#home'
end
