class ProjectsController < ApplicationController
  
  before_filter :authenticate_user!

  def invite
    @project = Project.find(params[:id])

    authorize @project, :adduser?

    respond_to do |format|
      format.html { render action: "invite" }
      format.json { head :no_content }
    end
  end

  def adduser
    @project = Project.find(params[:id])

    authorize @project

    if (!params[:user_id].nil?) then

      additionaluser = User.find(params[:user_id])

    else

      additionaluser = User.where(["email = ?", params[:email]]).first

      if (additionaluser.nil?) then

        User.invite!(:email => params[:email]) do |u|
          additionaluser = u
        end

        
      end

    end


    pm = ProjectMembership.new
    pm.user = additionaluser
    pm.project = @project
    pm.role_id = 88
    pm.save

    respond_to do |format|
      
        format.html { redirect_to projects_path, notice: 'User was successfully added to the Project.' }
        format.json { head :no_content }
      
    end

  end


  # GET /projects
  # GET /projects.json
  def index
    @projects =  ProjectPolicy::Scope.new(current_user, Project).resolve.order("created_at ASC")
    @jointprojects =  ProjectPolicy::JointScope.new(current_user, Project).resolve.order("created_at ASC")

    @current_user = current_user

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])

    authorize @project

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    authorize @project

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])

    authorize @project
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])

    authorize @project

    respond_to do |format|
      if @project.save

        pm = ProjectMembership.new
        pm.user = current_user
        pm.project = @project
        pm.role_id = 99
        pm.save

        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    authorize @project

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])

    authorize @project
    
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end
end
