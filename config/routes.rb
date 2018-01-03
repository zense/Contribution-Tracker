Rails.application.routes.draw do

  resources :contributions
  get '/auth/:provider/callback', to: 'sessions#create'
  root 'contributions#index'
  get '/logout', to:'sessions#destroy'

end
