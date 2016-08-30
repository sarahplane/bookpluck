Rails.application.routes.draw do
  resources :notecards

  root 'notecards#index'
end
