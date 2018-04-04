class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :add_mentees, :add_mentors]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  @@list_of_users = []
  def add_mentors
    @user = User.new
    @list_of_users = @@list_of_users
  end

  def new_mentor
    @user = User.find_by name: params_user[:name]

    @@list_of_users << @user unless @@list_of_users.include? @user
    puts "\n\n\n",@@list_of_users
    redirect_to add_mentors_path
  end


  def save_mentors
    @@list_of_users.each do |user|
      Role.create user_id: user.id, project_id: params[:id], role_type: 'mentor' unless user == nil
    end
    redirect_to project_path
  end

  def add_mentees
    @user = User.new
    @list_of_users = @@list_of_users
  end

  def new_mentee
    @user = User.find_by name: params_user[:name]
    @@list_of_users << @user unless @@list_of_users.include? @user
    redirect_to add_mentees_path
  end

  def save_mentees
    @@list_of_users.each do |user|
      Role.create user_id: user.id, project_id: params[:id], role_type: 'mentee' unless user == nil
    end
    redirect_to project_path
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
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
end
