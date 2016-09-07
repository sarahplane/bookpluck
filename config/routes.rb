Rails.application.routes.draw do
  controller :pages do
    get :home
  end

  resources :notecards

  root 'pages#home'
end
