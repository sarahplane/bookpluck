Rails.application.routes.draw do
  resources :notecards

  controller :pages do
    get :home
  end

  root 'pages#home'
end
