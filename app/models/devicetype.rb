class Devicetype < ActiveRecord::Base
  attr_accessible :deviceclass_id, :displayname, :name, :portbaud, :portdetails, :portname, :porttype, :showcase

  has_many :devices
end
