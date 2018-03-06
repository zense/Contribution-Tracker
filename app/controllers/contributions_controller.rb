class ContributionsController < ApplicationController
  before_action :set_contribution, only: [:show, :edit, :destroy]
  before_action :check_login

  # sds
  # GET /contributions
  # GET /contributions.json
  def index
    @contributions = current_user.contributions.reverse
    @time = "2018-01-01T00:00:00"
    @user = current_user
  end

  # GET /contributions/1
  # GET /contributions/1.json
  def show
    @time = "2018-01-01T00:00:00"
    @user = @contribution.user
  end

  # GET /contributions/new
  def new
    @contribution = Contribution.new
  end

  # GET /contributions/1/edit
  def edit
  end

  # POST /contributions
  # POST /contributions.json
  def create
    @contribution = Contribution.new(contribution_params)
    @contribution.status = "Pending"
    @contribution.user = current_user

    respond_to do |format|
      if @contribution.save
        format.html { redirect_to @contribution, notice: 'Contribution was successfully created.' }
        format.json { render :show, status: :created, location: @contribution }
      else
        format.html { render :new }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contributions/1
  # PATCH/PUT /contributions/1.json
  def update
    respond_to do |format|
      if @contribution.update(contribution_params)
        format.html { redirect_to pending_url, notice: 'Contribution was successfully updated.' }
        format.json { render :show, status: :ok, location: @contribution }
      else
        format.html { render :edit }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contributions/1
  # DELETE /contributions/1.json
  def destroy
    @contribution.destroy
    respond_to do |format|
      format.html { redirect_to contributions_url, notice: 'Contribution was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def pending
    @contribution = Contribution.where status: "Pending"
    @time = "2018-01-01T00:00:00"
  end

  def approve
    contribution_id = Integer(params[:id])
    @contribution = Contribution.find(contribution_id)
    @contribution.status = "Approved"
    @contribution.save
    redirect_to pending_url
  end

  def reject
    contribution_id = Integer(params[:id])
    @contribution = Contribution.find(contribution_id)
    @contribution.destroy
    redirect_to pending_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contribution
      @contribution = Contribution.find(params[:id])
    end

    def check_login
      if !current_user
        redirect_to login_url
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contribution_params
      params.require(:contribution).permit(:contribution_type, :name, :description, :status, :belongs_to)
    end
end
