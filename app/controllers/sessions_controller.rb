require 'fetch_contribution.rb'
class SessionsController < ApplicationController
  before_action :check_login, only: [:show]
  before_action :check_admin, only: [:fetch_contributions]

  def new
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    if user.valid?
      session[:user_id] = user.id
      redirect_to root_url
    end
  end

  def destroy
    reset_session
    redirect_to request.referer
  end

  def login
  end

  def fetch_contributions
    a = FetchGithubContribution.new.get_github_contributions
  end


  private
  def check_login
    if !current_user
      redirect_to login
    end
  end

  def check_admin
    if current_user
      current_user.admin
    else
      false
    end
  end

end
