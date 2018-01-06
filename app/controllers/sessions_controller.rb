class SessionsController < ApplicationController
  before_action :check_login, only: [:show, :members]
  def new
  end

  def show
    @user = User.find(params[:id])
    @contributions = @user.contributions
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

  def members
    @members = User.all
  end

  def login
  end

  private
  def check_login
    if !current_user
      redirect_to login
    end
  end

end
