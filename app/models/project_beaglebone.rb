class ProjectBeaglebone < ActiveRecord::Base
  attr_accessible :beaglebone_id, :project_id

  belongs_to :project
  belongs_to :beaglebone
end
