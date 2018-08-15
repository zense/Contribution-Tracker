Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
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
  get 'completed', to: 'projects#completed'
  get 'in_progress', to: 'projects#in_progress'
  get 'discarded', to: 'projects#discarded'

  get '/add_admin', to: 'users#addadmin', as: 'add_admin'
  get '/remove_admin', to: 'users#removeadmin', as: 'remove_admin'
  get '/leaderboard', to: 'users#leaderboard'
  get '/users/:id', to: 'users#show', as: 'user'
  get '/users', to: 'users#index', as: 'users'
  get 'assigned', to: 'users#assigned'
  get 'not_assigned', to: 'users#not_assigned'

  get '/auth/:provider/callback', to: 'sessions#create'
  root 'contributions#index'
  get '/logout', to:'sessions#destroy'
  get '/pending', to: 'contributions#pending'
  get '/approve', to: 'contributions#approve', as: 'approve'
  get '/reject', to: 'contributions#reject', as: 'reject'
  get '/login', to: 'sessions#login', as: 'login'
  get '/fetchcontributions', to: 'sessions#fetch_contributions', as: 'fetch_contributions'

end
