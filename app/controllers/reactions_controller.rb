class ReactionsController < ApplicationController

  before_filter :authenticate_user!

  before_action :set_reaction, only: [:show, :edit, :update, :destroy]

  # GET /reactions
  def index
    @reactions = ReactionPolicy::Scope.new(current_user, Reaction).resolve.paginate(:page => params[:page])

    @analytics = nil
  end

  # GET /reactions/1
  def show
    authorize @reaction

    if !current_user.nil? then @owndatasets = @reaction.datasets end
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

      @reaction.samples.each do |s|          

          s.molecule.add_to_project(current_user.rootproject_id) 
      end

      @reaction.update_attribute(:updated_at, DateTime.now)

      redirect_to @reaction, notice: 'Reaction was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /reactions/1
  def destroy
    authorize @reaction

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

        :products_attributes => [:id, :_destroy, :target_amount, :actual_amount, :unit, :mol, :equivalent, :yield, :is_virtual, {:molecule_attributes => [:id, :_destroy, :charge, :formula, :inchi, :inchikey, :mass, :molfile, :published_at, :spin, :smiles, :title]}, :molecule_id], 

        :educts_attributes => [:id, :_destroy, :target_amount, :actual_amount, :unit, :mol, :equivalent, :yield, :is_virtual, :is_startingmaterial, {:molecule_attributes => [:id, :_destroy, :charge, :formula, :inchi, :inchikey, :mass, :molfile, :published_at, :spin, :smiles, :title]}, :molecule_id],

        :reactants_attributes => [:id, :_destroy, :target_amount, :actual_amount, :unit, :mol, :equivalent, :yield, :is_virtual, :is_startingmaterial, {:molecule_attributes => [:id, :_destroy, :charge, :formula, :inchi, :inchikey, :mass, :molfile, :published_at, :spin, :smiles, :title]}, :molecule_id])
    end
end
