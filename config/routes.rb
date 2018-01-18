Rails.application.routes.draw do

  get 'auto_contributions/create'

  get 'auto_contributions/new'

  get 'auto_contributions/index'

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
  get '/add_admin', to: 'sessions#addadmin', as: 'add_admin'
  get '/remove_admin', to: 'sessions#removeadmin', as: 'remove_admin'

end
