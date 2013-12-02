class FolderWatchersController < ApplicationController
  before_action :set_folder_watcher, only: [:assign, :assign_do, :show, :edit, :update, :destroy]

  before_filter :authenticate_user!, except: [:heartbeat]

  protect_from_forgery :except => [:heartbeat]
  
  def heartbeat

    @bb = OpenStruct.new

    @folderwatchers = FolderWatcher.where (["serialnumber = ?", params[:serialnumber]])

    if (@folderwatchers.first) then

      @bb = @folderwatchers.first

    end

    render json: @bb
  end

  def assign

    authorize @folder_watcher

    @projects = current_user.projects

    respond_to do |format|
      format.html
      format.json { render json: @folder_watcher }
    end
  end

  def assign_do

    authorize @folder_watcher, :assign?

    @project = Project.find(params[:project_id])

    @folder_watcher.add_to_project(@project.id)

    redirect_to folder_watcher_path(@folder_watcher), notice: "Folder Watcher was assigned to project."
  end   

  # GET /folder_watchers
  # GET /folder_watchers.json
  def index
    @folder_watchers = FolderWatcherPolicy::Scope.new(current_user, FolderWatcher).resolve

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @folder_watchers }
    end
  end

  # GET /folder_watchers/1
  # GET /folder_watchers/1.json
  def show
    @folder_watcher = FolderWatcher.find(params[:id])

    authorize @folder_watcher

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @folder_watcher }
    end
  end

  # GET /folder_watchers/new
  # GET /folder_watchers/new.json
  def new
    @folder_watcher = FolderWatcher.new

    authorize @folder_watcher

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @folder_watcher }
    end
  end

  # GET /folder_watchers/1/edit
  def edit
    @folder_watcher = FolderWatcher.find(params[:id])
    authorize @folder_watcher
  end

  # POST /folder_watchers
  # POST /folder_watchers.json
  def create
    @folder_watcher = FolderWatcher.new(params[:folder_watcher])

    authorize @folder_watcher

    respond_to do |format|
      if @folder_watcher.save

        @folder_watcher.add_to_project(current_user.rootproject_id)

        format.html { redirect_to @folder_watcher, notice: 'Folder watcher was successfully created.' }
        format.json { render json: @folder_watcher, status: :created, location: @folder_watcher }
      else
        format.html { render action: "new" }
        format.json { render json: @folder_watcher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /folder_watchers/1
  # PUT /folder_watchers/1.json
  def update
    @folder_watcher = FolderWatcher.find(params[:id])

    authorize @folder_watcher

    respond_to do |format|
      if @folder_watcher.update_attributes(params[:folder_watcher])
        format.html { redirect_to @folder_watcher, notice: 'Folder watcher was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @folder_watcher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /folder_watchers/1
  # DELETE /folder_watchers/1.json
  def destroy
    @folder_watcher = FolderWatcher.find(params[:id])

    authorize @folder_watcher

    @folder_watcher.destroy

    respond_to do |format|
      format.html { redirect_to folder_watchers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_folder_watcher
      @folder_watcher = FolderWatcher.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def folder_watcher_params
      params.require(:folder_watcher).permit(:device_id, :pattern, :rootfolder, :scanfilter, :serialnumber)
    end
end
