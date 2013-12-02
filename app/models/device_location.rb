class DeviceLocation < ActiveRecord::Base
  attr_accessible :location_id, :device_id

  belongs_to :device
  belongs_to :location

end
