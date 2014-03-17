class SamplesController < ApplicationController
  before_action :set_sample, only: [:show, :edit, :update, :destroy, :assign, :assign_do, :fork]

  before_filter :authenticate_user!

  def assign
    authorize @sample, :edit?

    @projects = current_user.projects

    respond_to do |format|
      format.html
      format.json { render json: @sample }
    end
  end

  def assign_do
    authorize @sample, :edit?

    @project = Project.find(params[:project_id])

    @project.add_sample(@sample)

    redirect_to sample_path(@sample, :project_id => params[:project_id]), notice: "Sample and corresponding datasets were assigned to project."
  end   

  def createfrommolecule

    @molecule = Molecule.find(params[:molecule_id])
    @project = Project.find(params[:project_id])



  end

  def fork

    @project = Project.find(params[:project_id])

    s = Sample.new
    s.molecule = @sample.molecule
    s.target_amount = "0"
    s.unit = "mg"
    s.originsample_id = @sample.id
    s.save

    @sample.molecule.samples << s

    @sample.datasets.each do |ds|
      s.datasets << ds
    end

    @project.add_sample(s)

    redirect_to sample_path(s, :project_id => params[:project_id]), notice: "Sample was forked."
  end

  def index

    if params[:project_id].nil? then projid = current_user.rootproject_id else projid = params[:project_id] end

    @library = Library.find(Project.find(projid).rootlibrary_id)

    @library_entries = @library.library_entries

    render 'libraries/show', :id => @library.id

  end

  def show


    @library_entry = LibraryEntry.all.where(["sample_id = ?",  @sample.id]).first

    render 'library_entries/show', :id => @library_entry.id

  end


  def destroy
    authorize @sample

    @sample.destroy

    Reaction.find(params[:reaction_id]).update_attribute(:updated_at, DateTime.now)

    redirect_to reaction_url(Reaction.find(params[:reaction_id])), notice: 'Molecule was removed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sample
      @sample = Sample.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sample_params
      params.require(:sampl).permit(:target_amount, :actual_amount, :unit, :mol, :equivalent, :yield, :is_virtual, :is_startingmaterial, :molecule_attributes, :compound_id)
    end
end
