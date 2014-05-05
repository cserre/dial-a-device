class Location < ActiveRecord::Base

  has_many :device_locations
  has_many :devices,
    :through => :device_locations, :dependent => :destroy

end
