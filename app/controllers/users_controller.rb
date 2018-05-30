class UsersController < ApplicationController
  before_action :check_login
  def index
    @users = User.all
  end

  def assigned
    @users= User.all
  end
  
  def not_assigned
    @users= User.all
  end

  def show
    @user = User.find(params[:id])
    @contributions = @user.contributions
  end

  def leaderboard
    @users = User.joins(:contributions).group("users.id").order("count(users.id) DESC")
  end

  def addadmin
    add_admin = params[:add_user]
    add_admin.admin = true
    add_admin.save
  end

  def removeadmin
    remove_admin = User.find(params[:remove_user])
    remove_admin.admin = false
    remove_admin.save
  end

  private
    def check_login
      if !current_user
        redirect_to login_url
      end
    end
end
