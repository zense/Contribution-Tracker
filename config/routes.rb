Rails.application.routes.draw do

  get 'auto_contributions/create'

  get 'auto_contributions/new'

  get 'auto_contributions/index'

  resources :contributions, except: [:index]
  resources :users
  resources :projects
  get '/projects/:id/mentors', to: 'projects#add_mentors', as: 'add_mentors'
  get '/projects/:id/mentees', to: 'projects#add_mentees', as: 'add_mentees'
  post '/projects/:id/mentors', to: 'projects#new_mentor', as: 'new_mentor'
  post '/projects/:id/mentees', to: 'projects#new_mentee', as: 'new_mentee'
  get '/projects/:id/save_mentors', to: 'projects#save_mentors', as: 'save_mentors'
  get '/projects/:id/save_mentees', to: 'projects#save_mentees', as: 'save_mentees'
  get '/auth/:provider/callback', to: 'sessions#create'
  root 'contributions#index'
  get '/logout', to:'sessions#destroy'
  get '/pending', to: 'contributions#pending'
  get '/leaderboard', to: 'sessions#leaderboard'
  get '/users/:id', to: 'sessions#show'
  get '/approve', to: 'contributions#approve', as: 'approve'
  get '/reject', to: 'contributions#reject', as: 'reject'
  get '/login', to: 'sessions#login', as: 'login'
  get '/add_admin', to: 'sessions#addadmin', as: 'add_admin'
  get '/remove_admin', to: 'sessions#removeadmin', as: 'remove_admin'
  get '/fetchcontributions', to: 'sessions#fetch_contributions', as: 'fetch_contributions'

end
