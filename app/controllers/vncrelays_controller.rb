class VncrelaysController < ApplicationController
  before_action :set_vncrelay, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!, except: [:heartbeat]

  protect_from_forgery :except => [:heartbeat]

  def heartbeat

    @vncrelay = OpenStruct.new

    @vncrelays = Vncrelay.where (["serialnumber = ?", params[:serialnumber]])

    if (@vncrelays.first) then

      @vncrelay = @vncrelays.first

      @devices = Device.where (["vncrelay_id = ?", @vncrelay.id])

      if (@vncrelay) then

        @vncrelay.update_attribute(:lastseen, Time.now)

        @vncrelay.update_attribute(:internal_ip, params[:vncrelay][:ipaddress])

        @vncrelay.update_attribute(:external_ip, request.remote_ip)

        if (@devices.first) then

          @vncrelay = OpenStruct.new(:id => @vncrelay.id, :serialnumber => @vncrelay.serialnumber)

          @vncrelay.device = @devices.first

          @vncrelay.devicetype = @devices.first.devicetype
        end

      end

    end

    render json: @vncrelay
  end


  # GET /vncrelays
  def index
     @vncrelays = VncrelayPolicy::Scope.new(current_user, Vncrelay).resolve
  end

  # GET /vncrelays/1
  def show
    authorize @vncrelay
  end

  # GET /vncrelays/new
  def new
    
    @vncrelay = Vncrelay.new
    authorize @vncrelay
  end

  # GET /vncrelays/1/edit
  def edit
    authorize @vncrelay

  end

  # POST /vncrelays
  def create
    @vncrelay = Vncrelay.new(vncrelay_params)

    authorize @vncrelay

    if @vncrelay.save

      @vncrelay.add_to_project(current_user.rootproject_id)

      redirect_to @vncrelay, notice: 'Vncrelay was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /vncrelays/1
  def update
    authorize @vncrelay

    if @vncrelay.update(vncrelay_params)
      redirect_to @vncrelay, notice: 'Vncrelay was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /vncrelays/1
  def destroy
    authorize @vncrelay

    @vncrelay.destroy
    redirect_to vncrelays_url, notice: 'Vncrelay was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vncrelay
      @vncrelay = Vncrelay.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def vncrelay_params
      params.require(:vncrelay).permit(:host, :port, :lastseen, :serialnumber, :internal_ip, :external_ip)
    end
end
