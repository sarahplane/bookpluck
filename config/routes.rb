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

  resources :themes, only:[:index, :show, :destroy]

  root 'pages#home'
end
