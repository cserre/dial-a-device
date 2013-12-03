class Device < ActiveRecord::Base
  attr_accessible :devicetype_id, :connectiontype, :lastseen, :name, :beaglebone_id, :portname, :portbaud, :portdetails, :porttype, :vnchost, :vncpassword, :vncport, :websockifygateway, :websockifygatewayport

  belongs_to :devicetype

  has_many :device_locations
  has_many :locations,
    :through => :device_locations, :dependent => :destroy


  has_many :project_devices
  has_many :projects,
    through: :project_devices

  def add_to_project (project_id)

    pm = ProjectDevice.new
    pm.device_id = self.id
    pm.project_id = project_id
    pm.save

  end

end