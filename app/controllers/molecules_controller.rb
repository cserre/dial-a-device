class MoleculesController < ApplicationController

  before_filter :authenticate_user!, except: [:getdetails, :pick]
  
  def pick
    render :layout => false
  end

  def getdetails

    @mol = Molecule.new(params[:molecule])

    virtualmolecule = Rubabel::Molecule.from_molstring (@mol.molfile)
    
    # assign calculated molecule properties from OpenBabel
    @mol.smiles = virtualmolecule.to_s
    @mol.formula = virtualmolecule.formula.to_s
    @mol.mass = virtualmolecule.exact_mass.round(2).to_s
    @mol.inchi = virtualmolecule.to_s (:inchi)
    @mol.inchikey = virtualmolecule.to_s (:inchikey)
    @mol.charge = virtualmolecule.charge.round(2).to_s
    @mol.spin = virtualmolecule.spin.round(2).to_s
    @mol.title = "new "+virtualmolecule.smiles.to_s

    existingmolecules = Molecule.where (["smiles = ?", virtualmolecule.to_s])
    existingmolecule = existingmolecules.first

    if (existingmolecule != nil) then
      if (existingmolecule.id != nil) then
        @mol = existingmolecule
      end
    end

    respond_to do |format|
      format.json { render json: @mol }
    end
  end


  def assign
    @molecule = Molecule.find(params[:id])

    authorize @molecule

    @projects = current_user.projects

    respond_to do |format|
      format.html
      format.json { render json: @molecule }
    end
  end

  def assign_do
    @molecule = Molecule.find(params[:id])

    authorize @molecule, :assign?

    @project = Project.find(params[:project_id])

    @molecule.add_to_project(@project.id)

    redirect_to molecule_path(@molecule), notice: "Molecule was assigned to project."
  end   


  # GET /molecules
  # GET /molecules.json
  def index

    @filter = false
    inchikey = ""

    structurefilter = false
    titlefilter = false

    if !params[:molfile].nil? then
      filtermolfile = params[:molfile]


      virtualmolecule = Rubabel::Molecule.from_molstring (filtermolfile)

      @inchikey = virtualmolecule.to_s(:inchikey).strip
      @smiles = '%'+virtualmolecule.to_s+'%'


      structurefilter = true
    end

    if !params[:title].nil? then
      
      @title = '%'+params[:title]+'%'
      titlefilter = true
    end

    list = policy_scope(Molecule)

    if structurefilter then list = list.where(["smiles ilike ?", @smiles]) end
    if titlefilter then list = list.where(["molecules.title ilike ?", @title]) end

    if structurefilter then @filter = true end
    if titlefilter then @filter = true end

    @molecules = list


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @molecules }
    end
  end

  # GET /molecules/1
  # GET /molecules/1.json
  def show
    @molecule = Molecule.find(params[:id])

    authorize @molecule

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @molecule }
    end
  end

  # GET /molecules/new
  # GET /molecules/new.json
  def new
    @molecule = Molecule.new

    authorize @molecule

    @assign_to_project_id = params[:assign_to_project_id] || current_user.rootproject_id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @molecule }
    end
  end

  # GET /molecules/1/edit
  def edit
    @molecule = Molecule.find(params[:id])
    
    authorize @molecule
  end

  # POST /molecules
  # POST /molecules.json
  def create
    @molecule = Molecule.new(params[:molecule])

    authorize @molecule

    virtualmolecule = Rubabel::Molecule.from_molstring (@molecule.molfile)
    
    existingmolecules = Molecule.where (["smiles = ?", virtualmolecule.to_s])
    existingmolecule = existingmolecules.first

    if (existingmolecule != nil) then
      if (existingmolecule.id != nil) then
        existingmolecule.add_to_project(current_user.rootproject_id)
        success = true
        @molecule = existingmolecule

      end
    else
      success = @molecule.save
      @molecule.add_to_project(current_user.rootproject_id)
      @molecule.add_to_project(params[:assign_to_project_id])
    end
    
    respond_to do |format|
      if success

        format.html { redirect_to @molecule, notice: 'Molecule was successfully created.' }
        format.json { render json: @molecule, status: :created, location: @molecule }
      else
        format.html { render action: "new" }
        format.json { render json: @molecule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /molecules/1
  # PUT /molecules/1.json
  def update
    @molecule = Molecule.find(params[:id])

    authorize @molecule

    respond_to do |format|
      if @molecule.update_attributes(params[:molecule])
        format.html { redirect_to @molecule, notice: 'Molecule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @molecule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /molecules/1
  # DELETE /molecules/1.json
  def destroy
    @molecule = Molecule.find(params[:id])
    authorize @molecule

    @molecule.projects.delete (Project.find(current_user.rootproject_id))

    

    respond_to do |format|
      format.html { redirect_to molecules_url }
      format.json { head :no_content }
    end
  end
end
