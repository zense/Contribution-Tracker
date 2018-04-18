class ProjectsController < ApplicationController
  before_action :set_project, except: [:index,:new,:create]
  before_action :check_login
  before_action :check_admin, only: [:remove_users, :delete_user, :add_mentees, :add_mentors,:save_mentees,:save_mentors, :new_mentee,:new_mentor]


  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  def remove_users
    @mentors = @project.mentors
    @mentees = @project.mentees
  end

  def delete_user
    @role = Role.where(user_id: params[:user_id], project_id: @project.id)
    @role =@role.first
    Role.destroy @role.id
    redirect_to remove_users_path(@project.id)
  end


  def add_mentors
    @user = User.new
  end

  def new_mentor
    @user = User.find_by name: params_user[:name]
    Role.create user_id: @user.id, project_id: params[:id], role_type: 'mentor' 
    redirect_to add_mentors_path
  end


  def save_mentors
  end

  def add_mentees
    @user = User.new
  end

  def new_mentee
    @user = User.find_by name: params_user[:name]
    Role.create user_id: @user.id, project_id: params[:id], role_type: 'mentee' 
    redirect_to add_mentees_path
  end

  def save_mentees
  end



  # GET /projects/1
  # GET /projects/1.json
  def show
    @user = @project.mentees.first
    @contribution 
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :description)
    end

    def params_user
      name = params.require(:user).permit(:name)
    end

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
