class MoleculesController < ApplicationController

  before_filter :authenticate_user!, except: [:getdetails, :pick]

  
  class PubChem
    include HTTParty
    debug_output $stderr
    base_uri 'http://pubchem.ncbi.nlm.nih.gov/rest/pug'

    def initialize(user, password)
      @auth = {:username => user, :password => password}
    end

    def get_record(inchikey)
      # options = { :query => {:doi => doi, :url => url}, 
      #             :basic_auth => @auth, :headers => {'Content-Type' => 'text/plain'} }

      options = { :timeout => 3,  :headers => {'Content-Type' => 'text/json'}  }
      self.class.get('http://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/inchikey/'+inchikey+'/record/JSON', options)
    end

  end

  
  def pick
    render :layout => false
  end

  def getdetails

    @mol = Molecule.new(params[:molecule])

    virtualmolecule = Rubabel::Molecule.from_string(@mol.molfile, :mdl)

    if !virtualmolecule.nil? && !virtualmolecule.to_s.nil? then 
    
    # assign calculated molecule properties from OpenBabel
    @mol.smiles = virtualmolecule.to_s.gsub(/\n/, "").strip
    @mol.formula = virtualmolecule.formula.to_s.gsub(/\n/, "").strip
    @mol.mass = virtualmolecule.exact_mass.round(2).to_s.gsub(/\n/, "").strip
    @mol.inchi = virtualmolecule.to_s(:inchi).gsub(/\n/, "").strip
    @mol.inchikey = virtualmolecule.to_s(:inchikey).gsub(/\n/, "").strip
    @mol.charge = virtualmolecule.charge.round(2).to_s.gsub(/\n/, "").strip
    @mol.spin = virtualmolecule.spin.round(2).to_s.gsub(/\n/, "").strip
    @mol.title = "new "+virtualmolecule.smiles.to_s.gsub(/\n/, "").strip

    existingmolecules = Molecule.where (["inchikey = ?", @mol.inchikey])
    existingmolecule = existingmolecules.first

    else

      # search for existing molecule without openbabel

    end

    if (existingmolecule != nil) then

      if (existingmolecule.id != nil) then
        @mol = existingmolecule
      end

    elsif !@mol.inchikey.blank? then

      pccompound = PcCompound.where(["inchikey = ?", @mol.inchikey]).first

      if pccompound.blank? then

        pc = PubChem.new("", "")

        begin
          jsonresult = pc.get_record(@mol.inchikey)
        rescue
          jsonresult = nil
        end

        
        puts "---"
        puts jsonresult.to_s
        puts "---"
        pccompound = PcCompound.new

        if !jsonresult.nil? && !jsonresult["PC_Compounds"].nil? then

          pccompound.cid = jsonresult["PC_Compounds"][0]["id"]["id"]["cid"]

          jsonresult["PC_Compounds"][0]["props"].each do |prop|

            if (prop["urn"]["label"] == "IUPAC Name" && prop["urn"]["name"] == "Preferred") then
              pccompound.iupacname = prop["value"]["sval"].to_s

              @mol.title = pccompound.iupacname

            end
          end

          pccompound.inchikey = @mol.inchikey

          pccompound.save

        end

      else

        @mol.title = pccompound.iupacname

      end
    

    else

      @mol.title = "invalid"

    end


    
    respond_to do |format|
      format.json { render json: @mol }
    end
  end


  def assign

          @molecule = Molecule.find(params[:id])
    authorize @molecule, :assign?

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

    @project.add_molecule(@molecule)

    redirect_to molecule_path(@molecule, :project_id => params[:project_id]), notice: "Molecule was assigned to project."
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


      virtualmolecule = Rubabel::Molecule.from_string(filtermolfile, :mdl)

      @inchikey = virtualmolecule.to_s(:inchikey).strip
      @smiles = '%'+virtualmolecule.to_s+'%'


      structurefilter = true
    end

    if !params[:title].nil? then
      
      @title = '%'+params[:title]+'%'
      titlefilter = true
    end

    if params[:project_id].nil? then projid = current_user.rootproject_id else projid = params[:project_id] end

    list = policy_scope(Molecule).where(["projects.id = ?", projid])

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

    if !current_user.nil? then @owndatasets = current_user.datasets.where(["molecule_id = ?", @molecule.id]) end


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @molecule }
      format.svg {

        pagefile = Rails.root.join('tmp').join("mol_"+@molecule.inchikey.to_s+".svg")

        if File.exists?(pagefile) then

            pagecontent = File.read(pagefile)

        else

          pagecontent = @molecule.svg

          File.open(pagefile, "w") do |f|
            f.write (pagecontent)
          end

        end

        render :text => pagecontent

      }
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

    # GET /molecules/new
  # GET /molecules/new.json
  def addtoreaction
    @molecule = Molecule.new

    authorize @molecule, :new?

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

    reaction_id = params[:molecule][:reaction_id]
    role = params[:molecule][:role]
    project_id = params[:molecule][:project_id]

    params[:molecule].delete :reaction_id
    params[:molecule].delete :role
    params[:molecule].delete :project_id

    @molecule = Molecule.new(params[:molecule])

    authorize @molecule

    virtualmolecule = Rubabel::Molecule.from_string(@molecule.molfile, :mdl)
    
    existingmolecules = Molecule.where (["inchikey = ?", virtualmolecule.to_s(:inchikey).gsub(/\n/, "").strip])
    existingmolecule = existingmolecules.first

    if (existingmolecule != nil) then
      if (existingmolecule.id != nil) then
        success = true
        @molecule = existingmolecule

      end
    else
      success = @molecule.save
      
    end
    
    respond_to do |format|
      if success

        if Reaction.exists?(reaction_id) then

          r = Reaction.find(reaction_id)

          rp = ReactionPolicy.new(current_user, r)

          if rp.edit? then 


          s = Sample.new
          s.molecule = @molecule
          s.target_amount = "0"
          s.unit = "mg"
          

          if role == "educt" then 
            s.is_virtual = true
            s.is_startingmaterial = true
          end
          if role == "reactant" then 
            s.is_virtual = true
            s.is_startingmaterial = false
          end
          if role == "product" then 
            s.is_virtual = false
            s.is_startingmaterial = false
          end

          s.save

          @molecule.samples << s

          r.projects.each do |p|

            if current_user.projects.exists?(p) then
              p.add_sample(s)
            end

          end

          r.samples << s

          r.update_attribute(:updated_at, DateTime.now)

          format.html { redirect_to reaction_path(Reaction.find(reaction_id), :project_id => project_id), notice: 'Molecule was successfully added.' }
          format.json { render json: @molecule, status: :created, location: @molecule }

        else

          s = Sample.new
          s.molecule = @molecule
          s.target_amount = "0"
          s.unit = "mg"
          s.save

          @molecule.samples << s

          Project.find(params[:assign_to_project_id]).add_sample(s)

          format.html { redirect_to molecule_path(@molecule, :project_id => params[:assign_to_project_id]), notice: 'Molecule was successfully created.' }
          format.json { render json: @molecule, status: :created, location: @molecule }

        end

        else

          s = Sample.new
          s.molecule = @molecule
          s.target_amount = "0"
          s.unit = "mg"
          s.save

          @molecule.samples << s

          Project.find(params[:assign_to_project_id]).add_sample(s)

          format.html { redirect_to molecule_path(@molecule, :project_id => params[:assign_to_project_id]), notice: 'Molecule was successfully created.' }
          format.json { render json: @molecule, status: :created, location: @molecule }

        end
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

    current_user.projects.each do |p|

      @molecule.projects.delete (p)
    end

    if @molecule.projects.length == 0 then
      @molecule.destroy
    end
    

    respond_to do |format|
      format.html { redirect_to molecules_url }
      format.json { head :no_content }
    end
  end

  def import  
    require 'fileutils'
    @output = "please upload a database"

    if (params[:file_upload]) then

      tmp = params[:file_upload][:my_file].tempfile
      file = File.join("public", params[:file_upload][:my_file].original_filename)



      currentdatatype = ""
      currentdatum = "" 

      molecules = []

      molecule = {}

      moleculecounter = 0;

      molfile = ""

      molfilemode = false


      content = File.read(tmp)
      File.open(tmp).readlines.each do |line|

 
        line.encode!(Encoding::UTF_8, "windows-1252", :universal_newline => true)
  

        skipfirstline = false


        if (line.index(" ")) then

          keyword = line[0..line.index(" ")-1]
          value = line[line.index(" ")+1..-2]

          if (keyword == "$RIREG") then

            if (molfilemode) then
              molfilemode = false;
              molecule["molfile"] = molfile;
            end

            currentmolecule = value
            if (moleculecounter > 0) then 
              molecules.push (molecule)

              newcompound = Molecule.new

              newcompound.title = molecule["ROOT:SUBSTANZ"];
              newcompound.molfile = molecule["molfile"];

              moldetails = ChemRails.getmoldetails(newcompound.molfile)

              lowercasemoldetails = moldetails.each_with_object({}) do |(k,v), h|
                h[k.downcase] = v
              end

              # newcompound.assign_attributes(lowercasemoldetails, :without_protection => true)

              newcompound.add_to_project_recursive(current_user.rootproject_id)

              newcompound.save
              
              molecule = {}
            end
            moleculecounter += 1;
          end

          if (keyword == "$DTYPE") then

            if (value.start_with?  "ROOT:") then
              currentdatatype = value[5..value.length]
            else 
              currentdatatype = value
            end

            if (currentdatatype == "CAS_NR") then currentdatatype = "casnr" end


            if (molfilemode) then
              molfilemode = false;
              molecule["molfile"] = molfile;
            end

          end

          if (keyword == "$DATUM") then
            if (molfilemode) then
              molfilemode = false;
              molecule["molfile"] = molfile;
            end

            currentdatum = value
            if (value == "$MFMT") then

              molfilemode = true
              molfile = ""
              line = "\n"
            else
              molecule[currentdatatype] = currentdatum;
            end
                  
          end

        end #if line has space

        if (molfilemode && !skipfirstline) then 

          molfile += line

        end

      end # readline
        @output = molecules;

    end
  end

end
