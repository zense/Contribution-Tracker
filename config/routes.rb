Rails.application.routes.draw do

  resources :contributions, except: [:index]
  resources :projects


  scope '/projects/:id' do
    get 'mentors', to: 'projects#add_mentors', as: 'add_mentors'
    get 'mentees', to: 'projects#add_mentees', as: 'add_mentees'
    post 'mentors', to: 'projects#new_mentor', as: 'new_mentor'
    post 'mentees', to: 'projects#new_mentee', as: 'new_mentee'
    get 'save_mentors', to: 'projects#save_mentors', as: 'save_mentors'
    get 'save_mentees', to: 'projects#save_mentees', as: 'save_mentees'
    get 'remove_users', to: 'projects#remove_users', as: 'remove_users'
    get 'delete_user', to: 'projects#delete_user', as: 'delete_user'
  end

  get '/auth/:provider/callback', to: 'sessions#create'
  root 'contributions#index'
  get '/logout', to:'sessions#destroy'
  get '/pending', to: 'contributions#pending'
  get '/leaderboard', to: 'sessions#leaderboard'
  get '/users/:id', to: 'sessions#show', as: 'users'
  get '/approve', to: 'contributions#approve', as: 'approve'
  get '/reject', to: 'contributions#reject', as: 'reject'
  get '/login', to: 'sessions#login', as: 'login'
  get '/add_admin', to: 'sessions#addadmin', as: 'add_admin'
  get '/remove_admin', to: 'sessions#removeadmin', as: 'remove_admin'
  get '/fetchcontributions', to: 'sessions#fetch_contributions', as: 'fetch_contributions'

end
