Rails.application.routes.draw do

  controller :pages do
    get :home
  end


  devise_for :users, controllers: { sessions: 'users/sessions' }
  resources :notecards
  resources :books

  root 'pages#home'
end
