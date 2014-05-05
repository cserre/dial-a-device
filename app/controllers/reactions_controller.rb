class ReactionsController < ApplicationController

  before_filter :authenticate_user!

  before_action :set_reaction, only: [:show, :edit, :update, :destroy, :assign, :assign_do, :zip]

  # GET /reactions
  def index

    if params[:project_id].nil? then projid = current_user.rootproject_id else projid = params[:project_id] end
    @reactions = ReactionPolicy::Scope.new(current_user, Reaction).resolve.where(["projects.id = ?", projid]).paginate(:page => params[:page])

    @analytics = nil
  end

   def assign
    authorize @reaction, :edit?

    @projects = current_user.projects

    respond_to do |format|
      format.html
      format.json { render json: @reaction }
    end
  end

  def assign_do
    authorize @reaction, :edit?

    @project = Project.find(params[:project_id])

    @project.add_reaction(@reaction)

    redirect_to reaction_path(@reaction, :project_id => params[:project_id]), notice: "Reaction and corresponding samples were assigned to project."
  end   

  def zip

    authorize @reaction, :show?

    temp_file = Tempfile.new(@reaction.id.to_s+".zip")


    Zip::OutputStream.open(temp_file.path) { |zos| 

      zos.put_next_entry("reaction_"+@reaction.id.to_s+".json")
      zos.print @reaction.to_json

      @reaction.samples.each do |sample|

        sample.datasets.each do |dataset|

          dataset.attachments.each do |a|
            zos.put_next_entry(dataset.id.to_s+"/"+a.folder?+a.filename?)
            zos.print a.file.read
          end

        end

      end


    }

    temp_file.close

    send_data(File.read(temp_file.path), :type => 'application/zip', :filename => "reaction_"+@reaction.name.to_s+".zip")

  end

  # GET /reactions/1
  def show
    authorize @reaction

    if !current_user.nil? then @owndatasets = @reaction.datasets end

    if !params[:render].blank? && params[:render] == "inline" then 

        @device = Device.find(params[:device_id])

        render "showbalance", :layout => false

        return

    end
  end

  def createdirect
    @reaction = Reaction.new

    authorize @reaction, :create?

    namearray = Array.new

    current_user.reactions.each do |r|
      namearray << r.name
    end

    puts namearray

    if (current_user.sign != nil) then 

      stillsearching = true
      c = 1

      while stillsearching
        suggestedname = current_user.sign + "-" + c.to_s

        if !namearray.include?(suggestedname) then
          stillsearching = false
        end
        c = c + 1
        
      end

      @reaction.name = suggestedname
    end

    if @reaction.save

        if params[:assign_to_project_id].nil? then 

          current_user.rootproject.add_reaction(@reaction)

          @projid = current_user.rootproject

        else

          Project.find(params[:assign_to_project_id]).add_reaction(@reaction)

          @projid = params[:assign_to_project_id]

        end


      redirect_to reaction_path(@reaction, :project_id => @projid), notice: 'Reaction was successfully created.'
    else
      render action: 'new'
    end
  end

  # GET /reactions/new
  def new
    @reaction = Reaction.new

    authorize @reaction

    namearray = Array.new

    current_user.reactions.each do |r|
      namearray << r.name
    end

    puts namearray

    if (current_user.sign != nil) then 

      stillsearching = true
      c = 1

      while stillsearching
        suggestedname = current_user.sign + "-" + c.to_s

        if !namearray.include?(suggestedname) then
          stillsearching = false
        end
        c = c + 1
        
      end

      @reaction.name = suggestedname
    end

  end

  # GET /reactions/1/edit
  def edit
    authorize @reaction
  end

  # POST /reactions
  def create
    @reaction = Reaction.new(reaction_params)

    authorize @reaction


    if @reaction.save



        @reaction.samples.each do |s|          

          s.molecule.add_to_project(current_user.rootproject_id) 
          s.add_to_project(current_user.rootproject_id)
        end


        @reaction.add_to_project(current_user.rootproject_id)


      redirect_to @reaction, notice: 'Reaction was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /reactions/1
  def update
    authorize @reaction

    if @reaction.update(reaction_params)


      @reaction.update_attribute(:updated_at, DateTime.now)

      redirect_to @reaction, notice: 'Reaction was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /reactions/1
  def destroy
    authorize @reaction

    @reaction.samples.each do |s|

      s.datasets.each do |ds|

        ds.destroy

        ds.datasetgroups.destroy_all

      end

      LibraryEntry.where(["sample_id = ?", s.id]).destroy_all

      s.destroy

    end

    @reaction.destroy
    redirect_to reactions_url, notice: 'Reaction was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reaction
      @reaction = Reaction.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def reaction_params
      params.require(:reaction).permit(:name, :description, 

        :products_attributes => [:id, :_destroy, :target_amount, :actual_amount, :tare_amount, :unit, :mol, :equivalent, :yield, :is_virtual, {:molecule_attributes => [:id, :_destroy, :charge, :formula, :inchi, :inchikey, :mass, :molfile, :published_at, :spin, :smiles, :title]}, :molecule_id], 

        :educts_attributes => [:id, :_destroy, :target_amount, :actual_amount, :tare_amount, :unit, :mol, :equivalent, :yield, :is_virtual, :is_startingmaterial, {:molecule_attributes => [:id, :_destroy, :charge, :formula, :inchi, :inchikey, :mass, :molfile, :published_at, :spin, :smiles, :title]}, :molecule_id],

        :reactants_attributes => [:id, :_destroy, :target_amount, :actual_amount, :tare_amount, :unit, :mol, :equivalent, :yield, :is_virtual, :is_startingmaterial, {:molecule_attributes => [:id, :_destroy, :charge, :formula, :inchi, :inchikey, :mass, :molfile, :published_at, :spin, :smiles, :title]}, :molecule_id])
    end
end
