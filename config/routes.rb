Rails.application.routes.draw do

  resources :pages do
    collection do
      get :home
    end
  end


  devise_for :users
  resources :notecards
  resources :books
  resources :themes, only:(:show)

  root 'pages#home'
end
