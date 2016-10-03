Rails.application.routes.draw do

  resources :pages do
    collection do
      get :home
    end
  end

  devise_for :users
  resources :notecards do
    get "download"
  end

  resources :books
  resources :themes, only:[:index, :show]

  root 'pages#home'
end
