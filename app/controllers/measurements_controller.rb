class MeasurementsController < ApplicationController

  before_filter :authenticate_user!

  # GET /datasets
  # GET /datasets.json
  def index
    @measurements =  Measurement.where(["user_id = ?", current_user.id]).paginate(:page => params[:page]).order ("recorded_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @measurements }
    end
  end


  def import

    @measurement = Measurement.find(params[:id])

    @measurement.update_attributes(:user_id => current_user.id)

    @measurement.save


    # assign measurement to user

    # create suggestion

    # check if reaction exists

    # check if molecule exists

    # if all requirements are fulfilled, mark measurement as completed

    respond_to do |format|
        format.html { render action: "import" }
        format.json { render json: @measurement.errors, status: :unprocessable_entity }
      end
  end

  def discard

    @measurement = Measurement.find(params[:id])

    @measurement.update_attributes(:user_id => nil)

    @measurement.save


    # assign measurement to user

    # create suggestion

    # check if reaction exists

    # check if molecule exists

    # if all requirements are fulfilled, mark measurement as completed

    redirect_to measurements_path, notice: 'Measurement was discarded.'
  end


  def confirm

    @measurement = Measurement.find(params[:id])

    @ds = @measurement.dataset

    @r = Reaction.find(@measurement.reaction_id).first

    @r.projects.each do |p|
      @ds.add_to_project (p.id)
    end

    redirect_to @measurement.dataset, notice: "Dataset was imported."
  end


end
