Rails.application.routes.draw do

  resources :pages do
    collection do
      get :home
    end
  end

  devise_for :users
  resources :notecards do
    get "download_txt"
    get "download_html"
  end

  resources :books
  resources :themes, only:[:index, :show]

  root 'pages#home'
end
