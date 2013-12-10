class LibrariesController < ApplicationController

  before_filter :authenticate_user!

  before_action :set_library, only: [:show, :edit, :update, :destroy]

  # GET /libraries
  def index
    @libraries = policy_scope(Library)
  end

  # GET /libraries/1
  def show
    authorize @library

    @library_entries = @library.library_entries
  end

  # GET /libraries/new
  def new
    @library = Library.new

    authorize @library
  end

  # GET /libraries/1/edit
  def edit
    authorize @library
  end

  # POST /libraries
  def create
    @library = Library.new(library_params)

    authorize @library

    if @library.save
      @library.add_to_project(current_user.rootproject_id)

      redirect_to @library, notice: 'Library was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /libraries/1
  def update
    authorize @library
    if @library.update(library_params)
      redirect_to @library, notice: 'Library was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /libraries/1
  def destroy
    authorize @library
    @library.destroy
    redirect_to libraries_url, notice: 'Library was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_library
      @library = Library.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def library_params
      params.require(:library).permit(:title)
    end
end
