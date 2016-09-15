Rails.application.routes.draw do
  controller :pages do
    get :home
  end

  resources :notecards
  resources :books

  root 'pages#home'
end
