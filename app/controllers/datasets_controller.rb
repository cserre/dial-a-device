class DatasetsController < ApplicationController

  before_filter :authenticate_user!, except: [:show, :filter]

  # GET /datasets
  # GET /datasets.json
  def index
    @datasets =  policy_scope(Dataset)

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

      @dataset.title = params[:title]
      @dataset.method = params[:method]

      @dataset.save

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

      measurement = Measurement.new
      measurement.device_id = fw.device_id
      measurement.recorded_at = @dataset.created_at
      measurement.dataset_id = @dataset.id
      measurement.save

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

    @attachment = Attachment.new(:dataset => @dataset)

    respond_to do |format|
      format.html # show.html.erb
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

        format.html { redirect_to @dataset, notice: 'Dataset was successfully created.' }
        format.json { render json: @dataset, status: :created, location: @dataset }
      else
        format.html { render action: "new" }
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
        format.html { redirect_to @dataset, notice: 'Dataset was successfully updated.' }
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
