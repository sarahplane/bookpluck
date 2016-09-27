Rails.application.routes.draw do

  controller :pages do
    get :home
  end


  devise_for :users
  resources :notecards
  resources :books

  root 'pages#home'
end
