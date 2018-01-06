Rails.application.routes.draw do

  resources :contributions, except: [:index]
  get '/auth/:provider/callback', to: 'sessions#create'
  root 'contributions#index'
  get '/logout', to:'sessions#destroy'
  get '/pending', to: 'contributions#pending'
  get '/members', to: 'sessions#members'
  get '/members/:id', to: 'sessions#show'
  get '/approve', to: 'contributions#approve', as: 'approve'
  get '/reject', to: 'contributions#reject', as: 'reject'
  get '/login', to: 'sessions#login', as: 'login'

end
