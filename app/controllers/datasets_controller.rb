class DatasetsController < ApplicationController

  before_filter :authenticate_user!, except: [:show, :filter, :find, :finalize]

  # GET /datasets
  # GET /datasets.json
  def index
    @datasets =  policy_scope(Dataset).paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @datasets }
    end
  end

  def find
    @dataset =  Dataset.where(["uniqueid = ?", params[:uniqueid]]).first

    if @dataset.nil? then 
      @dataset = Dataset.new
      @dataset.uniqueid = params[:uniqueid]

      @dataset.title = URI.unescape(params[:title])
      @dataset.method = URI.unescape(params[:method])

      @dataset.save

      dsg = Datasetgroup.new
      dsg.save
      dsg.datasets << @dataset

      fw = FolderWatcher.where(["serialnumber = ?", params[:serialnumber]]).first

      fw.projects.each do |p|
        @dataset.add_to_project (p.id)
      end

    end

    resultjson = {
      :dataset => @dataset,
      :attachments => @dataset.attachments
    }

    render json: resultjson
  end

  def finalize
    @dataset =  Dataset.where(["uniqueid = ?", params[:uniqueid]]).first

    fw = FolderWatcher.where(["serialnumber = ?", params[:serialnumber]]).first

    if (!@dataset.nil? && !fw.nil?) then 

      if !(Commit.exists?(["dataset_id = ?", @dataset.id])) then 

        c = Commit.new
        c.dataset_id = @dataset.id
        #c.user_id = current_user.id
        c.save

        measurement = Measurement.new
        measurement.device_id = fw.device_id

        cd = DateTime.new(1982, 11, 10)

        if @dataset.recorded_at.nil? then        

          @dataset.attachments.each do |a|

            if a.filechange > cd then

              cd = a.filechange

            end
          end

        else
          cd = @dataset.recorded_at
        end

        measurement.recorded_at = cd
        
        measurement.dataset_id = @dataset.id
        measurement.save

        measurement.assign_to_user

      end

    end

    resultjson = {
      :dataset => @dataset,
      :attachments => @dataset.attachments
    }

    render json: resultjson
  end


  # GET /datasets
  # GET /datasets.json
  def filter

    @datasets = Dataset.where(["method = ?", params[:method]])

    respond_to do |format|
      format.html { render :template => "datasets/index" }
      format.json { render json: @datasets }
    end
  end

  # GET /datasets/1
  # GET /datasets/1.json
  def show
    @dataset = Dataset.find(params[:id])

    authorize @dataset

    @changerights = false

    if !current_user.nil? && current_user.datasetowner_of?(@dataset) then @changerights = true end

    if Commit.exists?(["dataset_id = ?", @dataset.id]) then @changerights = false end

    @attachment = Attachment.new(:dataset => @dataset)

    respond_to do |format|
      format.html { render action: "show", notice: 'Dataset is in change mode. Commit your changes after you\'re done.' unless !Commit.exists?(["dataset_id = ?", @dataset.id]) }
      format.json { render json: @dataset }
    end
  end

  # GET /datasets/new
  # GET /datasets/new.json
  def new
    @dataset = Dataset.new

    @dataset.molecule_id = params[:molecule_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dataset }
    end
  end

  # GET /datasets/1/edit
  def edit
    @dataset = Dataset.find(params[:id])

    authorize @dataset

    @reaction_id = params[:reaction_id]
  end


  def commit
    @dataset = Dataset.find(params[:id])

    authorize @dataset, :edit?

    c = Commit.new
    c.dataset_id = @dataset.id
    c.user_id = current_user.id

    respond_to do |format|
      if c.save
        format.html { redirect_to @dataset, notice: 'Dataset was successfully committed.' }
        format.json { head :no_content }
      else
        format.html { render action: "show" }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end

  end

  def create_direct
    @dataset = Dataset.new

    authorize @dataset, :create?

    @dataset.molecule_id = params[:molecule_id]
    @dataset.title = "no title"
    @dataset.method = "no method"
    @dataset.description = ""
    @dataset.details = ""

    if !@dataset.molecule.nil? then 

      assign_version_to_dataset @dataset, @dataset.molecule

    end

    assign_method_rank @dataset

    respond_to do |format|
      if @dataset.save

          if !(params[:reaction_id].nil?) then 

          dm = ReactionDataset.new
          dm.reaction_id = params[:reaction_id]
          dm.dataset_id = @dataset.id
          dm.save
        end

        @dataset.add_to_project(current_user.rootproject_id)

        if !@dataset.molecule.nil? then 


          @dataset.molecule.projects.each do |p|

            if current_user.projects.exists?(p) then
              @dataset.add_to_project(p.id)
            end
          end

        end

        dsg = Datasetgroup.new
        dsg.save
        dsg.datasets << @dataset

        format.html { redirect_to dataset_path(@dataset.id, :reaction_id => params[:reaction_id] , notice: 'Dataset was successfully created.') }
        format.json { render json: @dataset, status: :created, location: @dataset }
      else
        format.html { render action: "new" }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end

  end

  # POST /datasets
  # POST /datasets.json
  def create
    @dataset = Dataset.new(params[:dataset])

    authorize @dataset

    if !@dataset.molecule.nil? then 

      assign_version_to_dataset @dataset, @dataset.molecule

    end

    assign_method_rank @dataset

    respond_to do |format|
      if @dataset.save

        @dataset.add_to_project(current_user.rootproject_id)

        if !@dataset.molecule.nil? then 


          @dataset.molecule.projects.each do |p|

            if current_user.projects.exists?(p) then
              @dataset.add_to_project(p.id)
            end
          end

        end

        dsg = Datasetgroup.new
        dsg.save
        dsg.datasets << @dataset

        format.html { redirect_to @dataset, notice: 'Dataset was successfully created.' }
        format.json { render json: @dataset, status: :created, location: @dataset }
      else
        format.html { render action: "new" }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end
  end

  def copy_between_clouds(obj, src, dest)
    tmp = File.new("/tmp/tmp", "wb")
    begin
      filename = src.file.url
      File.open(tmp, "wb") do |file|
        file << open(filename).read
      end
      t = File.new(tmp)
      sf = CarrierWave::SanitizedFile.new(t)
      dest.file.store(sf)
    ensure
      File.delete(tmp)
    end
  end

  # POST /datasets
  # POST /datasets.json
  def fork

    @olddataset = Dataset.find(params[:id])

    authorize @olddataset, :show?

    @dataset = @olddataset.dup

    

#    if !@dataset.molecule.nil? then 

 #     assign_version_to_dataset @dataset, @dataset.molecule

  #  end

    respond_to do |format|

      if @dataset.save

        @dataset.add_to_project(current_user.rootproject_id)

        if !@dataset.molecule.nil? then 


          @dataset.molecule.projects.each do |p|

            if current_user.projects.exists?(p) then
              @dataset.add_to_project(p.id)
            end
          end

        end

        @olddataset.attachments.each do |a|

          newattachment = Attachment.new(:dataset => @dataset)

          if Rails.env.localserver? then 

            old_path = LsiRailsPrototype::Application.config.datasetroot + a.file_url
            puts old_path


            newattachment.file = File.new(old_path)

            new_path = LsiRailsPrototype::Application.config.datasetroot +  newattachment.file_url
            puts new_path

            FileUtils.mkdir_p(File.dirname(new_path))
            FileUtils.cp(old_path, new_path)

          else
            newattachment.remote_file_url = a.file_url
          end

          newattachment.save

          @dataset.attachments << newattachment

        end

        dsg = @olddataset.datasetgroups.first
        dsg.datasets << @dataset

        format.html { redirect_to @dataset, notice: 'Dataset was successfully forked.' }
        format.json { render json: @dataset, status: :created, location: @dataset }
      else
        format.html { redirect_to @olddataset, notice: 'Dataset could not be forked.' }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /datasets/1
  # PUT /datasets/1.json
  def update
    @dataset = Dataset.find(params[:id])

    authorize @dataset

    assign_method_rank @dataset



    respond_to do |format|
      if @dataset.update_attributes(params[:dataset])
        format.html { redirect_to dataset_path(@dataset.id, :reaction_id => params[:reaction_id], notice: 'Dataset was successfully updated.') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end
  end



  # DELETE /datasets/1
  # DELETE /datasets/1.json
  def destroy
    @dataset = Dataset.find(params[:id])
    authorize @dataset

    @dataset.destroy

    respond_to do |format|
      format.html { redirect_to datasets_url }
      format.json { head :no_content }
    end
  end



  private

  def assign_version_to_dataset (dataset, molecule)

    similarmethoddatasets = molecule.datasets.where(["method = ?", dataset.method])
    dataset.version = (similarmethoddatasets.length).to_s

  end

  def assign_method_rank (dataset)

    m = dataset.method

    r = 0

    if !m.nil? then
      if m.start_with?('Rf') then r = 10 end
      if m.start_with?('NMR/1H') then r = 20 end
      if m.start_with?('NMR/13C') then r = 30 end
      if m.start_with?('IR') then r = 40 end
      if m.start_with?('Mass') then r = 50 end
      if m.start_with?('GCMS') then r = 60 end
      if m.start_with?('Raman') then r = 65 end
      if m.start_with?('UV') then r = 70 end
      if m.start_with?('TLC') then r = 75 end
      if m.start_with?('Xray') then r = 80 end
    end

    dataset.method_rank = r

  end
end
